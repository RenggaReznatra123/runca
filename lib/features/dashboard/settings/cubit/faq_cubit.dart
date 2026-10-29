import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:runca/config/service_locator.dart';
import 'package:runca/repository/help_repository.dart';
import 'package:runca/utility/resource/data_state.dart';

import '../models/help_model.dart';
import 'faq_state.dart';

class FaqCubit extends Cubit<FaqState> {
  FaqCubit({HelpRepository? repository})
    : _repository = repository ?? serviceLocator.get<HelpRepository>(),
      super(const FaqState()) {
    loadFaqs();
  }

  static const Duration _searchDelay = Duration(milliseconds: 300);

  final HelpRepository _repository;

  Timer? _searchDebounce;

  // Dipakai untuk mengabaikan jawaban lama kalau ada permintaan yang lebih baru.
  int _requestId = 0;

  // Pertanyaan pertama dibuka otomatis hanya sekali, saat data pertama tiba.
  bool _hasOpenedFirst = false;

  /// Muat awal dan Try Again: layar menampilkan loading.
  Future<void> loadFaqs() => _fetch(showLoading: true);

  void selectFilter(FaqFilter filter) {
    if (filter == state.filter) return;

    _searchDebounce?.cancel();
    emit(state.copyWith(filter: filter));
    _fetch(showLoading: false);
  }

  void search(String query) {
    if (query == state.searchQuery) return;

    emit(state.copyWith(searchQuery: query));

    _searchDebounce?.cancel();
    _searchDebounce = Timer(_searchDelay, () => _fetch(showLoading: false));
  }

  /// Buka atau tutup satu pertanyaan.
  void toggleItem(String id) {
    final isOpen = state.expandedId == id;

    emit(
      state.copyWith(expandedId: isOpen ? null : id, clearExpandedId: isOpen),
    );
  }

  Future<void> _fetch({required bool showLoading}) async {
    final requestId = ++_requestId;
    final keyword = state.searchQuery.trim();

    if (showLoading) {
      emit(state.copyWith(status: FaqLoadStatus.loading));
    }

    final result = await _repository.getFaqs(
      category: state.filter.category,
      query: keyword.isEmpty ? null : keyword,
    );

    if (isClosed || requestId != _requestId) return;

    if (result is DataStateSuccess<List<FaqItem>>) {
      final items = result.data ?? const <FaqItem>[];
      var expandedId = state.expandedId;

      if (!_hasOpenedFirst && items.isNotEmpty) {
        expandedId = items.first.id;
        _hasOpenedFirst = true;
      } else if (!items.any((item) => item.id == expandedId)) {
        expandedId = null;
      }

      emit(
        state.copyWith(
          status: FaqLoadStatus.success,
          items: items,
          expandedId: expandedId,
          clearExpandedId: expandedId == null,
        ),
      );
    } else {
      emit(state.copyWith(status: FaqLoadStatus.failure));
    }
  }

  @override
  Future<void> close() {
    _searchDebounce?.cancel();
    return super.close();
  }
}

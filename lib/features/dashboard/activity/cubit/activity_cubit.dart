import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:runca/config/service_locator.dart';
import 'package:runca/repository/activity_repository.dart';
import 'package:runca/utility/resource/data_state.dart';

import '../models/activity_model.dart';
import 'activity_state.dart';

class ActivityCubit extends Cubit<ActivityState> {
  ActivityCubit({ActivityRepository? repository})
    : _repository = repository ?? serviceLocator.get<ActivityRepository>(),
      super(const ActivityState()) {
    loadActivities();

    // Muat ulang diam-diam kalau ada aktivitas baru atau berubah.
    _changesSubscription = _repository.changes.listen(
      (_) => _fetch(showLoading: false),
    );
  }

  static const Duration _searchDelay = Duration(milliseconds: 300);

  final ActivityRepository _repository;

  Timer? _searchDebounce;
  StreamSubscription<void>? _changesSubscription;

  // Dipakai untuk mengabaikan jawaban lama kalau ada permintaan yang lebih baru.
  int _requestId = 0;

  /// Muat awal dan tombol Try Again. Menampilkan loading.
  Future<void> loadActivities() => _fetch(showLoading: true);

  Future<void> refresh() => _fetch(showLoading: false, isRefresh: true);

  void clearRefreshError() {
    if (state.hasRefreshError) {
      emit(state.copyWith(hasRefreshError: false));
    }
  }

  void selectTab(ActivityTab tab) {
    if (tab == state.selectedTab) return;

    emit(state.copyWith(selectedTab: tab));
  }

  void selectFilter(ActivityFilter filter) {
    if (filter == state.selectedFilter) return;

    _searchDebounce?.cancel();
    emit(state.copyWith(selectedFilter: filter));
    _fetch(showLoading: false);
  }

  void search(String query) {
    if (query == state.searchQuery) return;

    emit(state.copyWith(searchQuery: query));

    _searchDebounce?.cancel();
    _searchDebounce = Timer(_searchDelay, () => _fetch(showLoading: false));
  }

  Future<void> _fetch({
    required bool showLoading,
    bool isRefresh = false,
  }) async {
    final requestId = ++_requestId;
    final type = state.selectedFilter.type;
    final keyword = state.searchQuery.trim();

    if (showLoading) {
      emit(
        state.copyWith(status: ActivityStatus.loading, hasRefreshError: false),
      );
    }

    final result = await _repository.getActivities(
      type: type,
      query: keyword.isEmpty ? null : keyword,
    );

    if (isClosed || requestId != _requestId) return;

    if (result is DataStateSuccess<List<ActivityModel>>) {
      emit(
        state.copyWith(
          status: ActivityStatus.success,
          activities: result.data ?? const [],
          hasRefreshError: false,
        ),
      );
    } else if (isRefresh) {
      emit(state.copyWith(hasRefreshError: true));
    } else {
      emit(
        state.copyWith(status: ActivityStatus.failure, hasRefreshError: false),
      );
    }
  }

  @override
  Future<void> close() {
    _searchDebounce?.cancel();
    _changesSubscription?.cancel();
    return super.close();
  }
}

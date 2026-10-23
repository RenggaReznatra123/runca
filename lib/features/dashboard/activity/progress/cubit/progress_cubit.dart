import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:runca/config/service_locator.dart';
import 'package:runca/repository/progress_repository.dart';
import 'package:runca/utility/resource/data_state.dart';

import '../../cubit/activity_state.dart';
import '../models/progress_model.dart';
import 'progress_state.dart';

class ProgressCubit extends Cubit<ProgressState> {
  ProgressCubit({ProgressRepository? repository})
    : _repository = repository ?? serviceLocator.get<ProgressRepository>(),
      super(ProgressState(selectedDate: _today())) {
    loadProgress();
  }

  final ProgressRepository _repository;

  // Dipakai untuk mengabaikan jawaban lama kalau ada permintaan yang lebih baru.
  int _requestId = 0;

  static DateTime _today() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  /// Muat awal dan tombol Try Again. Menampilkan loading.
  Future<void> loadProgress() async {
    final requestId = ++_requestId;
    final period = state.selectedPeriod;
    final date = state.selectedDate;
    final type = state.selectedFilter.type;

    emit(state.copyWith(status: ProgressStatus.loading));

    final (statsResult, recordsResult) = await (
      _repository.getStats(period: period, date: date, type: type),
      _repository.getPersonalRecords(),
    ).wait;

    if (isClosed || requestId != _requestId) return;

    if (statsResult is DataStateSuccess<ProgressStats> &&
        recordsResult is DataStateSuccess<PersonalRecords>) {
      emit(
        state.copyWith(
          status: ProgressStatus.success,
          stats: statsResult.data,
          records: recordsResult.data,
        ),
      );
    } else {
      emit(state.copyWith(status: ProgressStatus.failure));
    }
  }

  void selectPeriod(ProgressPeriod period) {
    if (period == state.selectedPeriod) return;

    emit(state.copyWith(selectedPeriod: period));
    _refreshStats();
  }

  void selectFilter(ActivityFilter filter) {
    if (filter == state.selectedFilter) return;

    emit(state.copyWith(selectedFilter: filter));
    _refreshStats();
  }

  void previousDate() => _moveDate(-1);

  void nextDate() => _moveDate(1);

  void _moveDate(int days) {
    final date = state.selectedDate;

    emit(
      state.copyWith(
        selectedDate: DateTime(date.year, date.month, date.day + days),
      ),
    );
    _refreshStats();
  }

  /// Ambil ulang statistik tanpa loading, konten lama tetap tampil
  /// sampai data baru datang.
  Future<void> _refreshStats() async {
    final requestId = ++_requestId;
    final period = state.selectedPeriod;
    final date = state.selectedDate;
    final type = state.selectedFilter.type;

    final result = await _repository.getStats(
      period: period,
      date: date,
      type: type,
    );

    if (isClosed || requestId != _requestId) return;

    if (result is DataStateSuccess<ProgressStats>) {
      emit(state.copyWith(status: ProgressStatus.success, stats: result.data));
    } else {
      emit(state.copyWith(status: ProgressStatus.failure));
    }
  }
}

import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:runca/config/service_locator.dart';
import 'package:runca/features/dashboard/activity/models/activity_draft.dart';
import 'package:runca/features/dashboard/activity/models/activity_model.dart';
import 'package:runca/repository/step_repository.dart';
import 'package:runca/utility/format_utils.dart';

import 'treadmill_tracking_state.dart';

class TreadmillTrackingCubit extends Cubit<TreadmillTrackingState> {
  TreadmillTrackingCubit({StepRepository? repository})
    : _repository = repository ?? serviceLocator.get<StepRepository>(),
      super(const TreadmillTrackingState()) {
    _start();
  }

  final StepRepository _repository;
  final Stopwatch _stopwatch = Stopwatch();

  /// Waktu mulai (setelah countdown), dipakai untuk judul dan tanggal.
  final DateTime startedAt = DateTime.now();

  Timer? _ticker;
  StreamSubscription<int>? _subscription;

  void _start() {
    _stopwatch.start();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
    _subscription = _repository.watchSteps().listen(
      _onSteps,
      onError: (Object _) {},
    );
  }

  void _tick() {
    if (state.status != TreadmillTrackingStatus.running) return;

    final seconds = _stopwatch.elapsed.inSeconds;
    if (seconds == state.durationSeconds) return;

    emit(state.copyWith(durationSeconds: seconds));
  }

  void _onSteps(int count) {
    // Langkah saat dijeda tidak dihitung.
    if (state.status != TreadmillTrackingStatus.running) return;

    emit(state.copyWith(steps: state.steps + count));
  }

  /// True kalau sudah ada data yang layak disimpan (Treadmill cukup durasi).
  bool get hasRecordedData => state.durationSeconds > 0;

  TreadmillFinishAttempt attemptFinish() {
    if (!hasRecordedData) return TreadmillFinishAttempt.noData;

    finish();
    return TreadmillFinishAttempt.finished;
  }

  /// ASUMSI: jarak, pace, dan kalori 0 karena belum ada sensor dan desain
  /// ringkasan Treadmill.
  ActivityDraft buildDraft() {
    return ActivityDraft(
      type: ActivityType.treadmill,
      title: AppFormat.defaultActivityTitle(
        startedAt,
        noun: ActivityType.treadmill.label,
      ),
      startedAt: startedAt,
      distanceKm: 0,
      durationSeconds: state.durationSeconds,
      avgPaceSecondsPerKm: 0,
      calories: 0,
      steps: state.steps,
      route: const [],
    );
  }

  void pause() {
    if (state.status != TreadmillTrackingStatus.running) return;

    _stopwatch.stop();
    emit(
      state.copyWith(
        status: TreadmillTrackingStatus.paused,
        durationSeconds: _stopwatch.elapsed.inSeconds,
      ),
    );
  }

  void resume() {
    if (state.status != TreadmillTrackingStatus.paused) return;

    _stopwatch.start();
    emit(state.copyWith(status: TreadmillTrackingStatus.running));
  }

  /// Mengunci layar (hanya saat berjalan).
  void lock() {
    if (state.status != TreadmillTrackingStatus.running) return;

    emit(state.copyWith(isLocked: true));
  }

  void unlock() {
    if (!state.isLocked) return;

    emit(state.copyWith(isLocked: false));
  }

  void finish() {
    if (state.status == TreadmillTrackingStatus.finished) return;

    _stopwatch.stop();
    _ticker?.cancel();
    _subscription?.cancel();

    emit(
      state.copyWith(
        status: TreadmillTrackingStatus.finished,
        durationSeconds: _stopwatch.elapsed.inSeconds,
      ),
    );
  }

  @override
  Future<void> close() async {
    _ticker?.cancel();
    await _subscription?.cancel();
    return super.close();
  }
}

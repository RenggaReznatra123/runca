import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:runca/config/service_locator.dart';
import 'package:runca/features/dashboard/activity/models/activity_model.dart';
import 'package:runca/repository/location_repository.dart';
import 'package:runca/repository/run_settings_repository.dart';
import 'package:runca/utility/resource/data_state.dart';

import '../models/location_fix.dart';
import '../models/run_goal.dart';
import '../models/run_settings.dart';
import '../models/run_start_decision.dart';
import 'run_state.dart';

class RunCubit extends Cubit<RunState> {
  RunCubit({
    LocationRepository? repository,
    RunSettingsRepository? settingsRepository,
  }) : _repository = repository ?? serviceLocator.get<LocationRepository>(),
       _settingsRepository =
           settingsRepository ?? serviceLocator.get<RunSettingsRepository>(),
       super(const RunState()) {
    startLocation();
    loadSettings();
  }

  final LocationRepository _repository;
  final RunSettingsRepository _settingsRepository;
  StreamSubscription<LocationFix>? _subscription;

  // Dipakai untuk mengabaikan jawaban lama kalau ada permintaan yang lebih baru.
  int _requestId = 0;

  // Pengaturan lari terakhir yang berhasil dimuat. Dibaca saat lari dimulai.
  RunSettings _settings = const RunSettings();
  Future<void> _settingsLoading = Future<void>.value();
  int _settingsRequestId = 0;

  /// Memuat pengaturan lari. Dipanggil saat layar dibuka dan setelah kembali
  /// dari Run Settings.
  Future<void> loadSettings() {
    final loading = _fetchSettings();
    _settingsLoading = loading;
    return loading;
  }

  Future<void> _fetchSettings() async {
    final requestId = ++_settingsRequestId;

    final result = await _settingsRepository.getSettings();

    if (isClosed || requestId != _settingsRequestId) return;

    if (result is DataStateSuccess<RunSettings>) {
      final data = result.data;
      if (data != null) _settings = data;
    }
  }

  /// Pengaturan terbaru. Menunggu kalau masih ada pemuatan yang berjalan.
  Future<RunSettings> readSettings() async {
    await _settingsLoading;
    return _settings;
  }

  Future<RunStartDecision> requestStart() async {
    final isTreadmill = state.activityType == ActivityType.treadmill;

    if (!isTreadmill &&
        state.locationStatus == RunLocationStatus.checking) {
      return const RunStartChecking();
    }

    if (!isTreadmill && state.locationStatus != RunLocationStatus.ready) {
      return RunStartBlocked(state.locationStatus);
    }

    return RunStartReady(await readSettings());
  }

  /// Memeriksa izin lalu mulai membaca lokasi. Dipanggil saat layar dibuka
  /// dan saat pengguna mencoba lagi.
  Future<void> startLocation() async {
    final requestId = ++_requestId;

    emit(state.copyWith(locationStatus: RunLocationStatus.checking));

    var permission = await _repository.checkPermission();
    if (permission == LocationPermissionResult.denied) {
      permission = await _repository.requestPermission();
    }

    if (isClosed || requestId != _requestId) return;

    switch (permission) {
      case LocationPermissionResult.granted:
        _watchLocation();
      case LocationPermissionResult.denied:
        emit(
          state.copyWith(locationStatus: RunLocationStatus.permissionDenied),
        );
      case LocationPermissionResult.deniedForever:
        emit(
          state.copyWith(
            locationStatus: RunLocationStatus.permissionDeniedForever,
          ),
        );
      case LocationPermissionResult.serviceDisabled:
        emit(state.copyWith(locationStatus: RunLocationStatus.serviceDisabled));
    }
  }

  void selectActivityType(ActivityType type) {
    if (type == state.activityType) return;

    emit(state.copyWith(activityType: type));
  }

  /// Menyimpan hasil sheet Set a Goal: target yang dipakai, dan isian
  /// terakhir di tiap tab (isian yang kosong tidak menimpa yang lama).
  void saveGoal(RunGoalSubmission submission) {
    emit(
      state.copyWith(
        goal: submission.goal,
        savedDistanceKm: submission.distanceKm,
        savedTimeSeconds: submission.timeSeconds,
      ),
    );
  }

  Future<void> openAppSettings() => _repository.openAppSettings();

  Future<void> openLocationSettings() => _repository.openLocationSettings();

  void _watchLocation() {
    _subscription?.cancel();

    emit(state.copyWith(locationStatus: RunLocationStatus.ready));

    _subscription = _repository.watchLocation().listen(
      (fix) => emit(state.copyWith(position: fix)),
      onError: (Object _) =>
          emit(state.copyWith(locationStatus: RunLocationStatus.failure)),
    );
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}
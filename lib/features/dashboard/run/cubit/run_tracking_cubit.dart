import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:runca/config/service_locator.dart';
import 'package:runca/features/dashboard/activity/models/activity_draft.dart';
import 'package:runca/features/dashboard/activity/models/activity_model.dart';
import 'package:runca/features/dashboard/profile/models/edit_profile_model.dart';
import 'package:runca/repository/location_repository.dart';
import 'package:runca/repository/profile_repository.dart';
import 'package:runca/utility/geo_utils.dart';
import 'package:runca/utility/resource/data_state.dart';

import '../models/location_fix.dart';
import 'run_tracking_state.dart';

class RunTrackingCubit extends Cubit<RunTrackingState> {
  RunTrackingCubit({
    required this._activityType,
    LocationFix? initialPosition,
    LocationRepository? repository,
    ProfileRepository? profileRepository,
  }) : _repository = repository ?? serviceLocator.get<LocationRepository>(),
       _profileRepository =
           profileRepository ?? serviceLocator.get<ProfileRepository>(),
       _lastCounted = initialPosition,
       super(
         RunTrackingState(
           position: initialPosition,
           route: initialPosition == null ? const [] : [initialPosition],
         ),
       ) {
    _start();
  }

  // Berat cadangan kalau profil gagal dimuat.
  static const double _defaultWeightKg = 60;

  // Pembacaan GPS dengan akurasi lebih buruk dari ini diabaikan (meter).
  static const double _maxAccuracyMeters = 30;

  // Gerakan lebih kecil dari ini dianggap getaran GPS saat diam (meter).
  static const double _minStepMeters = 2;

  final ActivityType _activityType;
  final LocationRepository _repository;
  final ProfileRepository _profileRepository;

  final Stopwatch _stopwatch = Stopwatch();

  /// Waktu lari mulai (setelah countdown), dipakai untuk judul dan tanggal.
  final DateTime startedAt = DateTime.now();

  Timer? _ticker;
  StreamSubscription<LocationFix>? _subscription;

  /// Titik terakhir yang dihitung jaraknya. Null berarti titik berikutnya
  /// hanya menjadi titik awal (awal lari atau setelah dilanjutkan dari jeda).
  LocationFix? _lastCounted;
  int _lastCountedAtMs = 0;

  double _weightKg = _defaultWeightKg;

  /// Kecepatan tertinggi yang masuk akal (m/s). Di atas ini dianggap loncatan GPS.
  double get _maxSpeedMetersPerSecond =>
      _activityType == ActivityType.cycling ? 25 : 12;

  /// Perkiraan kalori per kg berat badan per km.
  double get _caloriesPerKgKm =>
      _activityType == ActivityType.cycling ? 0.4 : 1.036;

  void _start() {
    _stopwatch.start();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
    _subscription = _repository.watchLocation().listen(
      _onFix,
      onError: (Object _) {},
    );
    _loadWeight();
  }

  Future<void> _loadWeight() async {
    final result = await _profileRepository.getEditProfile();

    if (isClosed) return;

    if (result is DataStateSuccess<EditProfileData>) {
      final data = result.data;
      if (data != null) _weightKg = data.weightKg.toDouble();
    }
  }

  int _caloriesFor(double distanceKm) {
    return (distanceKm * _weightKg * _caloriesPerKgKm).round();
  }

  void _tick() {
    if (state.status != RunTrackingStatus.running) return;

    final seconds = _stopwatch.elapsed.inSeconds;
    if (seconds == state.durationSeconds) return;

    emit(
      state.copyWith(
        durationSeconds: seconds,
        calories: _caloriesFor(state.distanceKm),
      ),
    );
  }

  void _onFix(LocationFix fix) {
    switch (state.status) {
      case RunTrackingStatus.finished:
        return;
      case RunTrackingStatus.paused:
        // Saat dijeda hanya titik lokasi yang bergerak.
        emit(state.copyWith(position: fix));
        return;
      case RunTrackingStatus.running:
        break;
    }

    final last = _lastCounted;
    final nowMs = _stopwatch.elapsedMilliseconds;

    if (last == null) {
      _lastCounted = fix;
      _lastCountedAtMs = nowMs;
      emit(state.copyWith(position: fix, route: [...state.route, fix]));
      return;
    }

    if (fix.accuracyMeters > _maxAccuracyMeters) {
      emit(state.copyWith(position: fix));
      return;
    }

    final meters = GeoUtils.distanceMeters(
      last.latitude,
      last.longitude,
      fix.latitude,
      fix.longitude,
    );
    final seconds = (nowMs - _lastCountedAtMs) / 1000;
    final tooSmall = meters < _minStepMeters;
    final tooFast = seconds > 0 && meters / seconds > _maxSpeedMetersPerSecond;

    if (tooSmall || tooFast) {
      emit(state.copyWith(position: fix));
      return;
    }

    final distanceKm = state.distanceKm + meters / 1000;

    _lastCounted = fix;
    _lastCountedAtMs = nowMs;

    emit(
      state.copyWith(
        position: fix,
        route: [...state.route, fix],
        distanceKm: distanceKm,
        calories: _caloriesFor(distanceKm),
      ),
    );
  }

  /// True kalau sudah ada data yang layak disimpan.
  /// Treadmill tidak punya GPS, jadi cukup durasi.
  bool get hasRecordedData => _activityType == ActivityType.treadmill
      ? state.durationSeconds > 0
      : state.distanceKm > 0;

  /// Mengubah hasil lari menjadi data yang dikirim ke repository.
  ActivityDraft buildDraft({required String title}) {
    final distanceKm = state.distanceKm;

    return ActivityDraft(
      type: _activityType,
      title: title,
      startedAt: startedAt,
      distanceKm: distanceKm,
      durationSeconds: state.durationSeconds,
      avgPaceSecondsPerKm: distanceKm > 0
          ? (state.durationSeconds / distanceKm).round()
          : 0,
      calories: state.calories,
      route: [
        for (final fix in state.route)
          RoutePoint(latitude: fix.latitude, longitude: fix.longitude),
      ],
    );
  }

  void pause() {
    if (state.status != RunTrackingStatus.running) return;

    _stopwatch.stop();
    emit(
      state.copyWith(
        status: RunTrackingStatus.paused,
        durationSeconds: _stopwatch.elapsed.inSeconds,
      ),
    );
  }

  void resume() {
    if (state.status != RunTrackingStatus.paused) return;

    // Gerakan selama jeda tidak dihitung: titik berikutnya jadi titik awal baru.
    _lastCounted = null;
    _stopwatch.start();
    emit(state.copyWith(status: RunTrackingStatus.running));
  }

  void finish() {
    if (state.status == RunTrackingStatus.finished) return;

    _stopwatch.stop();
    _ticker?.cancel();
    _subscription?.cancel();

    emit(
      state.copyWith(
        status: RunTrackingStatus.finished,
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
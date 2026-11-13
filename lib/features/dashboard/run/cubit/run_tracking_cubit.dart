import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:runca/config/service_locator.dart';
import 'package:runca/features/dashboard/activity/models/activity_draft.dart';
import 'package:runca/features/dashboard/activity/models/activity_model.dart';
import 'package:runca/features/dashboard/profile/models/edit_profile_model.dart';
import 'package:runca/repository/location_repository.dart';
import 'package:runca/repository/profile_repository.dart';
import 'package:runca/utility/format_utils.dart';
import 'package:runca/utility/geo_utils.dart';
import 'package:runca/utility/resource/data_state.dart';

import '../models/location_fix.dart';
import 'run_tracking_state.dart';

class RunTrackingCubit extends Cubit<RunTrackingState> {
  RunTrackingCubit({
    required this._activityType,
    LocationFix? initialPosition,
    bool autoPause = false,
    double? lapKm = 1,
    LocationRepository? repository,
    ProfileRepository? profileRepository,
  }) : _autoPauseEnabled = autoPause,
       _repository = repository ?? serviceLocator.get<LocationRepository>(),
       _profileRepository =
           profileRepository ?? serviceLocator.get<ProfileRepository>(),
       _lastCounted = initialPosition,
       super(
         RunTrackingState(
           position: initialPosition,
           route: initialPosition == null ? const [] : [initialPosition],
           lapDistanceKm: lapKm,
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

  // ASUMSI Auto Pause: dijeda kalau tidak ada gerakan terhitung selama ini,
  // dan lanjut kalau bergerak minimal sejauh ini dari titik jeda.
  static const int _autoPauseAfterMs = 5000;
  static const double _autoResumeMeters = 5;

  final ActivityType _activityType;
  final bool _autoPauseEnabled;
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

  // Kapan terakhir ada gerakan yang terhitung (milidetik Stopwatch).
  int _lastMovementMs = 0;

  // True kalau jeda terjadi otomatis (Auto Pause), titik tempat berhenti.
  bool _autoPaused = false;
  LocationFix? _autoPausePoint;

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

    if (_shouldAutoPause()) {
      _pauseAutomatically();
      return;
    }

    final seconds = _stopwatch.elapsed.inSeconds;
    if (seconds == state.durationSeconds) return;

    emit(
      state.copyWith(
        durationSeconds: seconds,
        calories: _caloriesFor(state.distanceKm),
      ),
    );
  }

  bool _shouldAutoPause() {
    return _autoPauseEnabled &&
        _stopwatch.elapsedMilliseconds - _lastMovementMs > _autoPauseAfterMs;
  }

  void _pauseAutomatically() {
    _autoPaused = true;
    _autoPausePoint = state.position;
    _stopwatch.stop();

    // Layar yang terkunci ikut terbuka supaya tombol Resume terlihat.
    emit(
      state.copyWith(
        status: RunTrackingStatus.paused,
        durationSeconds: _stopwatch.elapsed.inSeconds,
        isLocked: false,
      ),
    );
  }

  bool _shouldAutoResume(LocationFix fix) {
    if (fix.accuracyMeters > _maxAccuracyMeters) return false;

    final point = _autoPausePoint;
    if (point == null) return true;

    final meters = GeoUtils.distanceMeters(
      point.latitude,
      point.longitude,
      fix.latitude,
      fix.longitude,
    );

    return meters >= _autoResumeMeters;
  }

  /// Mencatat detik saat tiap lap penuh terlewati. Waktunya diinterpolasi
  /// di antara dua titik GPS supaya tidak melenceng.
  List<int> _lapEndsFor({
    required double fromKm,
    required double toKm,
    required int fromMs,
    required int toMs,
  }) {
    final lapKm = state.lapDistanceKm;
    if (lapKm == null) return state.lapEndSeconds;

    var ends = state.lapEndSeconds;
    var nextLap = ends.length + 1;

    while (nextLap * lapKm <= toKm) {
      final fraction = ((nextLap * lapKm - fromKm) / (toKm - fromKm)).clamp(
        0.0,
        1.0,
      );
      final ms = fromMs + (toMs - fromMs) * fraction;
      ends = [...ends, (ms / 1000).round()];
      nextLap++;
    }

    return ends;
  }

  void _onFix(LocationFix fix) {
    switch (state.status) {
      case RunTrackingStatus.finished:
        return;
      case RunTrackingStatus.paused:
        // Jeda otomatis: lanjut sendiri kalau pengguna sudah bergerak lagi.
        if (_autoPaused && _shouldAutoResume(fix)) {
          resume();
          _onFix(fix);
          return;
        }

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
      _lastMovementMs = nowMs;
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

    final previousKm = state.distanceKm;
    final distanceKm = previousKm + meters / 1000;
    final lapEndSeconds = _lapEndsFor(
      fromKm: previousKm,
      toKm: distanceKm,
      fromMs: _lastCountedAtMs,
      toMs: nowMs,
    );

    _lastCounted = fix;
    _lastCountedAtMs = nowMs;
    _lastMovementMs = nowMs;

    emit(
      state.copyWith(
        position: fix,
        route: [...state.route, fix],
        distanceKm: distanceKm,
        calories: _caloriesFor(distanceKm),
        lapEndSeconds: lapEndSeconds,
      ),
    );
  }

  /// True kalau sudah ada data yang layak disimpan.
  /// Treadmill tidak punya GPS, jadi cukup durasi.
  bool get hasRecordedData => _activityType == ActivityType.treadmill
      ? state.durationSeconds > 0
      : state.distanceKm > 0;

  RunFinishAttempt attemptFinish() {
    if (!hasRecordedData) return RunFinishAttempt.noData;

    finish();
    return RunFinishAttempt.finished;
  }

  /// Mengubah hasil lari menjadi data yang dikirim ke repository.
  ActivityDraft buildDraft() {
    final distanceKm = state.distanceKm;
    final noun = _activityType == ActivityType.cycling ? 'Ride' : 'Run';

    return ActivityDraft(
      type: _activityType,
      title: AppFormat.defaultActivityTitle(startedAt, noun: noun),
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

    _autoPaused = false;
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
    _autoPaused = false;
    _lastCounted = null;
    _stopwatch.start();
    _lastMovementMs = _stopwatch.elapsedMilliseconds;
    emit(state.copyWith(status: RunTrackingStatus.running));
  }

  /// Mengunci layar (hanya saat lari berjalan).
  void lock() {
    if (state.status != RunTrackingStatus.running) return;

    emit(state.copyWith(isLocked: true));
  }

  void unlock() {
    if (!state.isLocked) return;

    emit(state.copyWith(isLocked: false));
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
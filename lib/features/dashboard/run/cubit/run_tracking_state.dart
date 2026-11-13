import '../models/location_fix.dart';
import '../models/run_split.dart';

enum RunTrackingStatus { running, paused, finished }

enum RunFinishAttempt { finished, noData }

class RunTrackingState {
  const RunTrackingState({
    this.status = RunTrackingStatus.running,
    this.position,
    this.route = const [],
    this.distanceKm = 0,
    this.durationSeconds = 0,
    this.calories = 0,
    this.lapEndSeconds = const [],
    this.lapDistanceKm,
    this.isLocked = false,
  });

  // Jarak minimum sebelum pace dihitung, supaya angkanya tidak melonjak di awal.
  static const double _minPaceDistanceKm = 0.05;

  final RunTrackingStatus status;

  /// Lokasi terakhir. Null berarti belum ada sinyal GPS.
  final LocationFix? position;

  /// Titik-titik rute yang sudah ditempuh.
  final List<LocationFix> route;

  final double distanceKm;
  final int durationSeconds;
  final int calories;

  /// Detik (sejak mulai) saat tiap lap selesai. Indeks 0 = lap pertama.
  final List<int> lapEndSeconds;

  /// Jarak satu lap (km) dari pengaturan Auto Lap. Null berarti Auto Lap mati.
  final double? lapDistanceKm;

  /// True kalau layar dikunci.
  final bool isLocked;

  bool get autoLapEnabled => lapDistanceKm != null;

  /// Pace rata-rata dalam detik per km. Null kalau jarak belum cukup.
  int? get paceSecondsPerKm {
    if (distanceKm < _minPaceDistanceKm) return null;

    return (durationSeconds / distanceKm).round();
  }

  /// Daftar split: tiap lap yang selesai, ditambah lap yang sedang berjalan.
  /// Kosong kalau Auto Lap mati.
  List<RunSplit> get splits {
    final lapKm = lapDistanceKm;
    if (lapKm == null) return const [];

    final result = <RunSplit>[];
    var previousEnd = 0;
    int? previousPace;

    for (var i = 0; i < lapEndSeconds.length; i++) {
      final lapSeconds = lapEndSeconds[i] - previousEnd;
      final pace = (lapSeconds / lapKm).round();

      result.add(
        RunSplit(
          index: i + 1,
          distanceKm: (i + 1) * lapKm,
          paceSecondsPerKm: pace,
          deltaSeconds: previousPace == null ? null : pace - previousPace,
        ),
      );

      previousEnd = lapEndSeconds[i];
      previousPace = pace;
    }

    final partialKm = distanceKm - lapEndSeconds.length * lapKm;
    final partialSeconds = durationSeconds - previousEnd;

    if (partialKm >= _minPaceDistanceKm && partialSeconds > 0) {
      final pace = (partialSeconds / partialKm).round();

      result.add(
        RunSplit(
          index: lapEndSeconds.length + 1,
          distanceKm: (lapEndSeconds.length + 1) * lapKm,
          paceSecondsPerKm: pace,
          deltaSeconds: previousPace == null ? null : pace - previousPace,
          isCurrent: true,
        ),
      );
    }

    return result;
  }

  RunTrackingState copyWith({
    RunTrackingStatus? status,
    LocationFix? position,
    List<LocationFix>? route,
    double? distanceKm,
    int? durationSeconds,
    int? calories,
    List<int>? lapEndSeconds,
    bool? isLocked,
  }) {
    return RunTrackingState(
      status: status ?? this.status,
      position: position ?? this.position,
      route: route ?? this.route,
      distanceKm: distanceKm ?? this.distanceKm,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      calories: calories ?? this.calories,
      lapEndSeconds: lapEndSeconds ?? this.lapEndSeconds,
      lapDistanceKm: lapDistanceKm,
      isLocked: isLocked ?? this.isLocked,
    );
  }
}
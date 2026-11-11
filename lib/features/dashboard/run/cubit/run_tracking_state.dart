import '../models/location_fix.dart';
import '../models/run_split.dart';

enum RunTrackingStatus { running, paused, finished }

class RunTrackingState {
  const RunTrackingState({
    this.status = RunTrackingStatus.running,
    this.position,
    this.route = const [],
    this.distanceKm = 0,
    this.durationSeconds = 0,
    this.calories = 0,
    this.kmEndSeconds = const [],
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

  /// Detik (sejak mulai) saat tiap kilometer penuh selesai. Indeks 0 = km 1.
  final List<int> kmEndSeconds;

  /// True kalau layar dikunci.
  final bool isLocked;

  /// Pace rata-rata dalam detik per km. Null kalau jarak belum cukup.
  int? get paceSecondsPerKm {
    if (distanceKm < _minPaceDistanceKm) return null;

    return (durationSeconds / distanceKm).round();
  }

  /// Daftar split: tiap km yang selesai, ditambah km yang sedang berjalan.
  List<RunSplit> get splits {
    final result = <RunSplit>[];
    var previousEnd = 0;
    int? previousPace;

    for (var i = 0; i < kmEndSeconds.length; i++) {
      final pace = kmEndSeconds[i] - previousEnd;
      result.add(
        RunSplit(
          km: i + 1,
          paceSecondsPerKm: pace,
          deltaSeconds: previousPace == null ? null : pace - previousPace,
        ),
      );
      previousEnd = kmEndSeconds[i];
      previousPace = pace;
    }

    final partialKm = distanceKm - kmEndSeconds.length;
    final partialSeconds = durationSeconds - previousEnd;

    if (partialKm >= _minPaceDistanceKm && partialSeconds > 0) {
      final pace = (partialSeconds / partialKm).round();
      result.add(
        RunSplit(
          km: kmEndSeconds.length + 1,
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
    List<int>? kmEndSeconds,
    bool? isLocked,
  }) {
    return RunTrackingState(
      status: status ?? this.status,
      position: position ?? this.position,
      route: route ?? this.route,
      distanceKm: distanceKm ?? this.distanceKm,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      calories: calories ?? this.calories,
      kmEndSeconds: kmEndSeconds ?? this.kmEndSeconds,
      isLocked: isLocked ?? this.isLocked,
    );
  }
}
import '../models/location_fix.dart';

enum RunTrackingStatus { running, paused, finished }

class RunTrackingState {
  const RunTrackingState({
    this.status = RunTrackingStatus.running,
    this.position,
    this.route = const [],
    this.distanceKm = 0,
    this.durationSeconds = 0,
    this.calories = 0,
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

  /// Pace rata-rata dalam detik per km. Null kalau jarak belum cukup.
  int? get paceSecondsPerKm {
    if (distanceKm < _minPaceDistanceKm) return null;

    return (durationSeconds / distanceKm).round();
  }

  RunTrackingState copyWith({
    RunTrackingStatus? status,
    LocationFix? position,
    List<LocationFix>? route,
    double? distanceKm,
    int? durationSeconds,
    int? calories,
  }) {
    return RunTrackingState(
      status: status ?? this.status,
      position: position ?? this.position,
      route: route ?? this.route,
      distanceKm: distanceKm ?? this.distanceKm,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      calories: calories ?? this.calories,
    );
  }
}
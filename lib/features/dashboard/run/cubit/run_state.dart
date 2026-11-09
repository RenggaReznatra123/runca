import 'package:runca/features/dashboard/activity/models/activity_model.dart';

import '../models/location_fix.dart';
import '../models/run_goal.dart';

enum RunLocationStatus {
  checking,
  ready,
  permissionDenied,
  permissionDeniedForever,
  serviceDisabled,
  failure,
}

class RunState {
  const RunState({
    this.locationStatus = RunLocationStatus.checking,
    this.position,
    this.activityType = ActivityType.running,
    this.goal,
    this.savedDistanceKm,
    this.savedTimeSeconds,
    this.distanceKm = 0,
    this.durationSeconds = 0,
    this.paceSecondsPerKm,
    this.calories = 0,
  });

  final RunLocationStatus locationStatus;

  /// Lokasi terakhir. Null berarti belum ada sinyal GPS.
  final LocationFix? position;
  final ActivityType activityType;

  /// Target lari yang sedang dipakai. Null berarti tanpa target.
  final RunGoal? goal;

  /// Isian terakhir yang disimpan di tiap tab sheet Set a Goal.
  final double? savedDistanceKm;
  final int? savedTimeSeconds;

  /// Nilai statistik. Tahap Setup masih nol, tahap Tracking mengisinya.
  final double distanceKm;
  final int durationSeconds;
  final int? paceSecondsPerKm;
  final int calories;

  RunState copyWith({
    RunLocationStatus? locationStatus,
    LocationFix? position,
    ActivityType? activityType,
    RunGoal? goal,
    double? savedDistanceKm,
    int? savedTimeSeconds,
  }) {
    return RunState(
      locationStatus: locationStatus ?? this.locationStatus,
      position: position ?? this.position,
      activityType: activityType ?? this.activityType,
      goal: goal ?? this.goal,
      savedDistanceKm: savedDistanceKm ?? this.savedDistanceKm,
      savedTimeSeconds: savedTimeSeconds ?? this.savedTimeSeconds,
      distanceKm: distanceKm,
      durationSeconds: durationSeconds,
      paceSecondsPerKm: paceSecondsPerKm,
      calories: calories,
    );
  }
}

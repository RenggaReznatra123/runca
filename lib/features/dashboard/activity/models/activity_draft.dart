import 'activity_model.dart';

/// Data lari yang baru selesai, dikirim ke repository untuk disimpan.
/// Server yang akan memberi id.
class ActivityDraft {
  const ActivityDraft({
    required this.type,
    required this.title,
    required this.startedAt,
    required this.distanceKm,
    required this.durationSeconds,
    required this.avgPaceSecondsPerKm,
    required this.calories,
    required this.route,
  });

  final ActivityType type;
  final String title;
  final DateTime startedAt;
  final double distanceKm;
  final int durationSeconds;
  final int avgPaceSecondsPerKm;
  final int calories;
  final List<RoutePoint> route;
}

enum NotificationType { reminder, streak, activity, weeklyProgress }

class NotificationModel {
  const NotificationModel({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.type,
    this.imageUrl,
    this.highlighted = false,
    this.activity,
    this.progress,
  });

  final String id;
  final String title;
  final String description;
  final DateTime createdAt;
  final NotificationType type;
  final bool highlighted;
  final String? imageUrl;
  final ActivitySummary? activity;
  final WeeklyProgress? progress;
}

class ActivitySummary {
  const ActivitySummary({
    required this.title,
    required this.distanceKm,
    required this.durationSeconds,
    required this.paceSecondsPerKm,
    required this.calories,
  });

  final String title;
  final double distanceKm;
  final int durationSeconds;
  final int paceSecondsPerKm;
  final int calories;
}

class WeeklyProgress {
  const WeeklyProgress({
    required this.distanceKm,
    required this.calories,
    required this.paceSecondsPerKm,
    required this.durationSeconds,
  });

  final double distanceKm;
  final int calories;
  final int paceSecondsPerKm;
  final int durationSeconds;
}

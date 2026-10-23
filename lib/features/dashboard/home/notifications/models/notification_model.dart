import 'package:flutter/material.dart';

import 'package:runca/ui/color.dart';

enum NotificationType { reminder, streak, activity, weeklyProgress }

class NotificationModel {
  const NotificationModel({
    required this.title,
    required this.description,
    required this.time,
    required this.type,
    this.actionLabel,
    this.activity,
    this.progress,
    this.highlighted = false,
  });

  final String title;
  final String description;
  final String time;
  final NotificationType type;
  final String? actionLabel;
  final ActivitySummary? activity;
  final WeeklyProgress? progress;
  final bool highlighted;

  IconData get icon {
    switch (type) {
      case NotificationType.reminder:
        return Icons.directions_run_rounded;
      case NotificationType.streak:
        return Icons.local_fire_department_rounded;
      case NotificationType.activity:
        return Icons.directions_run_rounded;
      case NotificationType.weeklyProgress:
        return Icons.show_chart_rounded;
    }
  }

  Color get iconColor {
    switch (type) {
      case NotificationType.reminder:
        return AppPalette.bgFillSecondary;
      case NotificationType.streak:
        return AppPalette.textWarning;
      case NotificationType.activity:
      case NotificationType.weeklyProgress:
        return AppPalette.bgFillPrimary;
    }
  }
}

class ActivitySummary {
  const ActivitySummary({
    required this.title,
    required this.distance,
    required this.duration,
    required this.pace,
    required this.calories,
  });

  final String title;
  final String distance;
  final String duration;
  final String pace;
  final String calories;
}

class WeeklyProgress {
  const WeeklyProgress({
    required this.distance,
    required this.calories,
    required this.pace,
    required this.duration,
  });

  final String distance;
  final String calories;
  final String pace;
  final String duration;
}

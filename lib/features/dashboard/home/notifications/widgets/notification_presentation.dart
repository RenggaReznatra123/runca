import 'package:flutter/material.dart';
import 'package:runca/ui/color.dart';

import '../models/notification_model.dart';

extension NotificationPresentation on NotificationType {
  IconData get icon => switch (this) {
    NotificationType.reminder => Icons.directions_run_rounded,
    NotificationType.streak => Icons.local_fire_department_rounded,
    NotificationType.activity => Icons.directions_run_rounded,
    NotificationType.weeklyProgress => Icons.show_chart_rounded,
  };

  Color get iconColor => switch (this) {
    NotificationType.reminder => AppPalette.bgFillSecondary,
    NotificationType.streak => AppPalette.textWarning,
    NotificationType.activity ||
    NotificationType.weeklyProgress => AppPalette.bgFillPrimary,
  };

  String? get actionLabel => switch (this) {
    NotificationType.reminder => null,
    NotificationType.streak => 'Start Run',
    NotificationType.activity => 'View Activity',
    NotificationType.weeklyProgress => 'View Progress',
  };
}

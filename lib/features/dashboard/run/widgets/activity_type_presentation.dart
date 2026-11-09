import 'package:flutter/material.dart';

import 'package:runca/features/dashboard/activity/models/activity_model.dart';

extension ActivityTypePresentation on ActivityType {
  IconData get icon => switch (this) {
    ActivityType.running => Icons.directions_run_rounded,
    ActivityType.treadmill => Icons.fitness_center_rounded,
    ActivityType.cycling => Icons.directions_bike_rounded,
  };
}

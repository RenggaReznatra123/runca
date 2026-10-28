import 'package:flutter/material.dart';
import 'package:runca/features/dashboard/activity/progress/models/progress_model.dart';
import 'package:runca/features/dashboard/activity/progress/widgets/personal_record_item.dart';
import 'package:runca/ui/color.dart';
import 'package:runca/utility/format_utils.dart';

class PersonalRecordsList extends StatelessWidget {
  const PersonalRecordsList({required this.records, super.key});

  final PersonalRecords records;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PersonalRecordItem(
          key: const ValueKey('longest_distance'),
          icon: Icons.route_outlined,
          iconColor: AppPalette.iconPrimary,
          label: 'Longest Distance',
          value: AppFormat.distanceValue(records.longestDistanceKm),
          unit: 'km',
        ),
        const SizedBox(height: 10),
        PersonalRecordItem(
          key: const ValueKey('longest_streak'),
          icon: Icons.local_fire_department_rounded,
          iconColor: AppPalette.iconSecondary,
          label: 'Longest Streak',
          value: AppFormat.integer(records.longestStreakDays),
          unit: AppFormat.dayUnit(records.longestStreakDays),
        ),
        const SizedBox(height: 10),
        PersonalRecordItem(
          key: const ValueKey('best_pace'),
          icon: Icons.bolt_outlined,
          iconColor: AppPalette.iconPrimary,
          label: 'Best Pace',
          value: AppFormat.pace(records.bestPaceSecondsPerKm),
          unit: '/km',
        ),
      ],
    );
  }
}

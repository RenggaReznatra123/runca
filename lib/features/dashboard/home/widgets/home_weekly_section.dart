import 'package:flutter/material.dart';

import 'package:runca/features/dashboard/home/models/home_model.dart';

import 'home_activity_toggle.dart';
import 'home_section_header.dart';
import 'weekly_stats.dart';

/// Bagian "This Week": judul, toggle Indoor/Outdoor, dan statistik mingguan.
class HomeWeeklySection extends StatelessWidget {
  const HomeWeeklySection({
    super.key,
    required this.stats,
    required this.activityType,
    required this.onActivityTypeChanged,
  });

  final WeeklyStatsData stats;
  final HomeActivityType activityType;
  final ValueChanged<HomeActivityType> onActivityTypeChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HomeSectionHeader(
            title: 'This Week',
            trailing: HomeActivityToggle(
              selected: activityType,
              onChanged: onActivityTypeChanged,
            ),
          ),
          const SizedBox(height: 14),
          WeeklyStats(stats: stats),
        ],
      ),
    );
  }
}
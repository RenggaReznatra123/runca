import 'package:flutter/material.dart';
import 'package:runca/features/dashboard/home/models/home_model.dart';
import 'package:runca/ui/color.dart';
import 'package:runca/utility/format_utils.dart';

class WeeklyStats extends StatelessWidget {
  const WeeklyStats({super.key, required this.stats});

  final WeeklyStatsData stats;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _StatCard(
                icon: Icons.route_outlined,
                iconColor: AppPalette.bgFillPrimary,
                title: 'Total Distance',
                value: AppFormat.distanceValue(stats.distanceKm),
                unit: 'km',
                comparison:
                    '${stats.distanceIncreased ? '↑' : '↓'} '
                    '${AppFormat.distanceValue(stats.distanceChangeKm)} vs last week',
                positive: stats.distanceIncreased,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _StatCard(
                icon: Icons.local_fire_department_rounded,
                iconColor: AppPalette.textWarning,
                title: 'Calories',
                value: AppFormat.thousands(stats.calories),
                unit: 'kcal',
                comparison:
                    '${stats.caloriesIncreased ? '↑' : '↓'} '
                    '${AppFormat.thousands(stats.caloriesChange)} vs last week',
                positive: stats.caloriesIncreased,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _StatCard(
                icon: Icons.bolt_rounded,
                iconColor: AppPalette.textInfo,
                title: 'Avg Pace',
                value: stats.paceSecondsPerKm == null
                    ? '-:-'
                    : AppFormat.pace(stats.paceSecondsPerKm!),
                unit: '/km',
                comparison:
                    '${stats.paceIncreased ? '↑' : '↓'} '
                    '${AppFormat.change(stats.paceChangePercent, isPercent: true)} vs last week',
                positive: stats.paceIncreased,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _StatCard(
                icon: Icons.access_time_filled_rounded,
                iconColor: AppPalette.bgFillPrimary,
                title: 'Duration',
                value: AppFormat.clockDuration(stats.durationSeconds),
                unit: '',
                comparison:
                    '${stats.durationIncreased ? '↑' : '↓'} '
                    '${stats.durationChangeMinutes}m vs last week',
                positive: stats.durationIncreased,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.value,
    required this.unit,
    required this.comparison,
    required this.positive,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String value;
  final String unit;
  final String comparison;
  final bool positive;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppPalette.bgSurfaceNeutral,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 13, 8, 11),
            child: Row(
              children: [
                Icon(icon, size: 20, color: iconColor),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppPalette.textNeutralPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            color: AppPalette.bg,
            padding: const EdgeInsets.fromLTRB(12, 13, 8, 13),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        value,
                        style: const TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.w400,
                          color: AppPalette.textNeutralPrimary,
                        ),
                      ),
                      if (unit.isNotEmpty) ...[
                        const SizedBox(width: 4),
                        Text(
                          unit,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppPalette.textNeutralSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  comparison,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    color: positive
                        ? AppPalette.textSuccess
                        : AppPalette.textDanger,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

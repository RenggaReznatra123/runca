import 'package:flutter/material.dart';

import 'package:runca/ui/color.dart';
import 'package:runca/ui/shared_view/app_image.dart';
import 'package:runca/ui/typography.dart';
import 'package:runca/utility/format_utils.dart';

import '../../activity/models/activity_model.dart';

/// Aktivitas terakhir di Home: thumbnail peta, info, dan empat statistik.
class LastActivityCard extends StatelessWidget {
  const LastActivityCard({super.key, required this.activity});

  final ActivityModel activity;

  static const double _mapWidth = 156;
  static const double _mapHeight = 92;

  IconData _iconFor(ActivityType type) {
    switch (type) {
      case ActivityType.running:
        return Icons.directions_run_rounded;
      case ActivityType.treadmill:
        return Icons.fitness_center_rounded;
      case ActivityType.cycling:
        return Icons.directions_bike_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: AppImage(
                path: activity.mapImageUrl,
                width: _mapWidth,
                height: _mapHeight,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        _iconFor(activity.type),
                        size: 14,
                        color: AppPalette.textPrimary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        activity.type.label,
                        style: AppTypography.bodySmall(
                          color: AppPalette.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    activity.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.bodyMedium(
                      color: AppPalette.textNeutralPrimary,
                    ).copyWith(height: 24 / 14),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    AppFormat.lastActivityDateTime(activity.startedAt),
                    style: AppTypography.bodySmall(
                      color: AppPalette.textNeutralSecondary,
                    ).copyWith(fontSize: 11),
                  ),
                ],
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _Stat(
                  value: AppFormat.distanceNumber(activity.distanceKm),
                  label: 'Distance (km)',
                ),
              ),
              Expanded(
                child: _Stat(
                  value: AppFormat.duration(activity.durationSeconds),
                  label: 'Duration',
                ),
              ),
              Expanded(
                child: _Stat(
                  value: AppFormat.pace(activity.avgPaceSecondsPerKm),
                  label: 'Avg Pace /km',
                ),
              ),
              Expanded(
                child: _Stat(
                  value: AppFormat.thousands(activity.calories),
                  label: 'Calories (kcal)',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(
            value,
            maxLines: 1,
            style: AppTypography.bodyMedium(
              color: AppPalette.textNeutralPrimary,
            ).copyWith(fontWeight: AppTypography.medium),
          ),
        ),
        const SizedBox(height: 2),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(
            label,
            maxLines: 1,
            style: AppTypography.bodySmall(
              color: AppPalette.textNeutralSecondary,
            ).copyWith(fontSize: 10),
          ),
        ),
      ],
    );
  }
}
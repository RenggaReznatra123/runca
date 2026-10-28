import 'package:flutter/material.dart';

import 'package:runca/ui/color.dart';
import 'package:runca/ui/typography.dart';
import 'package:runca/utility/format_utils.dart';

import '../models/activity_model.dart';
import 'activity_map_thumbnail.dart';
import 'activity_stat.dart';

class ActivityItem extends StatelessWidget {
  const ActivityItem({super.key, required this.activity});

  final ActivityModel activity;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppPalette.baseWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppPalette.baseBlack.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ActivityMapThumbnail(imagePath: activity.mapImageUrl),
              const SizedBox(width: 20),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 11, 16, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.directions_run_rounded,
                            size: 14,
                            color: AppPalette.bgFillPrimary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            activity.type.label,
                            style: AppTypography.bodySmall(
                              color: AppPalette.textNeutralPrimary,
                            ).copyWith(fontSize: 11),
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
                      const SizedBox(height: 7),
                      Text(
                        AppFormat.activityDateTime(activity.startedAt),
                        style: AppTypography.bodySmall(
                          color: AppPalette.textNeutralSecondary,
                        ).copyWith(fontSize: 11),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ActivityStat(
                    value: AppFormat.distanceKm(activity.distanceKm),
                    label: 'Distance',
                  ),
                ),
                Expanded(
                  child: ActivityStat(
                    value: AppFormat.duration(activity.durationSeconds),
                    label: 'Duration',
                  ),
                ),
                Expanded(
                  child: ActivityStat(
                    value: AppFormat.pace(activity.avgPaceSecondsPerKm),
                    label: 'Avg Pace',
                  ),
                ),
                Expanded(
                  child: ActivityStat(
                    value: AppFormat.calories(activity.calories),
                    label: 'Calories',
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

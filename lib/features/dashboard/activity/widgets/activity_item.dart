import 'package:flutter/material.dart';

import 'package:runca/ui/color.dart';
import 'package:runca/ui/typography.dart';
import 'package:runca/utility/format_utils.dart';

import '../models/activity_model.dart';

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
              _MapThumbnail(imagePath: activity.mapImageUrl),
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
                  child: _ActivityStat(
                    value: AppFormat.distanceKm(activity.distanceKm),
                    label: 'Distance',
                  ),
                ),
                Expanded(
                  child: _ActivityStat(
                    value: AppFormat.duration(activity.durationSeconds),
                    label: 'Duration',
                  ),
                ),
                Expanded(
                  child: _ActivityStat(
                    value: AppFormat.pace(activity.avgPaceSecondsPerKm),
                    label: 'Avg Pace',
                  ),
                ),
                Expanded(
                  child: _ActivityStat(
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

class _MapThumbnail extends StatelessWidget {
  const _MapThumbnail({this.imagePath});

  final String? imagePath;

  static const double _width = 168;
  static const double _height = 116;

  @override
  Widget build(BuildContext context) {
    final path = imagePath;

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: path == null ? _placeholder() : _image(path),
    );
  }

  Widget _image(String path) {
    if (path.startsWith('http')) {
      return Image.network(
        path,
        width: _width,
        height: _height,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => _placeholder(),
      );
    }

    return Image.asset(
      path,
      width: _width,
      height: _height,
      fit: BoxFit.cover,
      errorBuilder: (_, _, _) => _placeholder(),
    );
  }

  Widget _placeholder() {
    return Container(
      width: _width,
      height: _height,
      color: AppPalette.bgSurfaceNeutral,
      alignment: Alignment.center,
      child: const Icon(
        Icons.map_outlined,
        size: 32,
        color: AppPalette.textNeutralSecondary,
      ),
    );
  }
}

class _ActivityStat extends StatelessWidget {
  const _ActivityStat({required this.value, required this.label});

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
            style: AppTypography.titleMedium(
              color: AppPalette.textNeutralPrimary,
            ).copyWith(fontSize: 16, height: 1.5),
          ),
        ),
        Text(
          label,
          maxLines: 1,
          style: AppTypography.bodySmall(
            color: AppPalette.textNeutralSecondary,
          ).copyWith(fontSize: 11),
        ),
      ],
    );
  }
}
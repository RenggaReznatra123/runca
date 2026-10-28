import 'package:flutter/material.dart';
import 'package:runca/ui/color.dart';
import 'package:runca/ui/typography.dart';
import 'package:runca/utility/format_utils.dart';

import '../models/notification_model.dart';

class NotificationActivitySummary extends StatelessWidget {
  const NotificationActivitySummary({required this.activity, super.key});

  final ActivitySummary activity;

  static const Color _textColor = AppPalette.textNeutralPrimary;
  static const Color _secondaryColor = AppPalette.textNeutralSecondary;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(7),
          child: Container(
            width: 64,
            height: 46,
            color: AppPalette.bgSurfaceNeutral,
            alignment: Alignment.center,
            child: const Icon(
              Icons.map_outlined,
              color: _secondaryColor,
              size: 25,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                activity.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.titleSmall(color: _textColor).copyWith(
                  fontSize: 12,
                  fontWeight: AppTypography.medium,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                '${AppFormat.distanceKm(activity.distanceKm)} · '
                '${AppFormat.duration(activity.durationSeconds)}',
                style: AppTypography.bodyMedium(
                  color: _secondaryColor,
                ).copyWith(fontSize: 11.5),
              ),
              const SizedBox(height: 2),
              Text(
                '${AppFormat.pacePerKm(activity.paceSecondsPerKm)} · '
                '${AppFormat.calories(activity.calories)}',
                style: AppTypography.bodyMedium(
                  color: _secondaryColor,
                ).copyWith(fontSize: 11.5),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

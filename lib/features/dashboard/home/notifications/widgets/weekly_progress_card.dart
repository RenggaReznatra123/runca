import 'package:flutter/material.dart';

import 'package:runca/ui/color.dart';
import 'package:runca/ui/typography.dart';
import 'package:runca/utility/format_utils.dart';
import '../models/notification_model.dart';

class WeeklyProgressCard extends StatelessWidget {
  const WeeklyProgressCard({super.key, required this.progress});

  final WeeklyProgress progress;

  @override
  Widget build(BuildContext context) {
    final items = [
      ('${AppFormat.distanceValue(progress.distanceKm)} km', 'Total Distance'),
      (AppFormat.calories(progress.calories), 'Calories'),
      (AppFormat.pacePerKm(progress.paceSecondsPerKm), 'Avg Pace'),
      (AppFormat.clockDuration(progress.durationSeconds), 'Duration'),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        mainAxisExtent: 84,
      ),
      itemBuilder: (context, index) {
        final item = items[index];

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppPalette.bg,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                item.$1,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style:
                    AppTypography.titleMedium(
                      color: AppPalette.textNeutralPrimary,
                    ).copyWith(
                      fontSize: 19,
                      fontWeight: AppTypography.medium,
                      height: 1.3,
                    ),
              ),
              const SizedBox(height: 5),
              Text(
                item.$2,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.bodyMedium(
                  color: AppPalette.textNeutralSecondary,
                ).copyWith(fontSize: 14),
              ),
            ],
          ),
        );
      },
    );
  }
}

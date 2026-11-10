import 'package:flutter/material.dart';

import 'package:runca/ui/color.dart';
import 'package:runca/ui/typography.dart';
import 'package:runca/utility/format_utils.dart';

/// Empat statistik ringkasan dalam grid 2x2.
class RunSummaryStats extends StatelessWidget {
  const RunSummaryStats({
    super.key,
    required this.distanceKm,
    required this.durationSeconds,
    required this.paceSecondsPerKm,
    required this.calories,
  });

  final double distanceKm;
  final int durationSeconds;
  final int paceSecondsPerKm;
  final int calories;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _Stat(
                value: AppFormat.distanceNumber(distanceKm),
                label: 'Distance (km)',
              ),
            ),
            Expanded(
              child: _Stat(
                value: AppFormat.clockDuration(durationSeconds),
                label: 'Duration',
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _Stat(
                value: AppFormat.thousands(calories),
                label: 'Calories (kcal)',
              ),
            ),
            Expanded(
              child: _Stat(
                value: AppFormat.paceOrPlaceholder(
                  paceSecondsPerKm > 0 ? paceSecondsPerKm : null,
                ),
                label: 'Avg Pace (/km)',
              ),
            ),
          ],
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
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            value,
            maxLines: 1,
            style: AppTypography.headlineSmall(
              color: AppPalette.textNeutralPrimary,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          maxLines: 1,
          style: AppTypography.bodyMedium(color: AppPalette.profileMutedText),
        ),
      ],
    );
  }
}
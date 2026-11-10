import 'package:flutter/material.dart';

import 'package:runca/ui/color.dart';
import 'package:runca/ui/typography.dart';
import 'package:runca/utility/format_utils.dart';

import '../models/activity_model.dart';

/// Enam statistik dalam grid 3x2. Avg HR dan Elev Gain belum direkam
/// aplikasi, jadi tampil "–".
class ActivityDetailStats extends StatelessWidget {
  const ActivityDetailStats({super.key, required this.activity});

  final ActivityModel activity;

  static const String _empty = '\u2013';

  @override
  Widget build(BuildContext context) {
    final pace = activity.avgPaceSecondsPerKm;

    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _Stat(
                value: AppFormat.distanceValue(activity.distanceKm),
                label: 'Distance',
              ),
            ),
            Expanded(
              child: _Stat(
                value: pace > 0 ? AppFormat.duration(pace) : _empty,
                unit: pace > 0 ? '/km' : null,
                label: 'Avg Pace',
              ),
            ),
            Expanded(
              child: _Stat(
                value: AppFormat.duration(activity.durationSeconds),
                label: 'Duration',
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        const Divider(height: 1, color: AppPalette.borderNeutral),
        const SizedBox(height: 20),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _Stat(
                value: AppFormat.thousands(activity.calories),
                label: 'Calories',
              ),
            ),
            const Expanded(
              child: _Stat(value: _empty, label: 'Avg HR'),
            ),
            const Expanded(
              child: _Stat(value: _empty, label: 'Elev Gain'),
            ),
          ],
        ),
      ],
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.value, required this.label, this.unit});

  final String value;
  final String label;
  final String? unit;

  @override
  Widget build(BuildContext context) {
    final unitText = unit;

    return Column(
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                maxLines: 1,
                style: AppTypography.headlineSmall(
                  color: AppPalette.textNeutralPrimary,
                ).copyWith(fontWeight: AppTypography.bold),
              ),
              if (unitText != null) ...[
                const SizedBox(width: 4),
                Text(
                  unitText,
                  style: AppTypography.bodySmall(
                    color: AppPalette.profileMutedText,
                  ),
                ),
              ],
            ],
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

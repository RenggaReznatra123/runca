import 'package:flutter/material.dart';

import 'package:runca/ui/color.dart';
import 'package:runca/ui/typography.dart';
import 'package:runca/utility/format_utils.dart';

/// Dua angka utama ringkasan Treadmill: Time dan Steps.
class TreadmillSummaryStats extends StatelessWidget {
  const TreadmillSummaryStats({
    super.key,
    required this.durationSeconds,
    required this.steps,
  });

  final int durationSeconds;
  final int steps;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _Stat(
            value: AppFormat.duration(durationSeconds),
            label: 'Time',
          ),
        ),
        Expanded(
          child: _Stat(value: AppFormat.thousands(steps), label: 'Steps'),
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
        SizedBox(
          height: 64,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              maxLines: 1,
              style: AppTypography.headlineSmall(
                color: AppPalette.textNeutralPrimary,
              ).copyWith(fontSize: 48, fontWeight: AppTypography.bold),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          maxLines: 1,
          style: AppTypography.bodyLarge(color: AppPalette.profileMutedText),
        ),
      ],
    );
  }
}

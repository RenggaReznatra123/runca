import 'package:flutter/material.dart';
import 'package:runca/ui/color.dart';
import 'package:runca/ui/typography.dart';

class ProgressPeriodPlaceholder extends StatelessWidget {
  const ProgressPeriodPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: Center(
        child: Text(
          'Design for this period is not available yet.',
          textAlign: TextAlign.center,
          style: AppTypography.bodyMedium(
            color: AppPalette.textNeutralSecondary,
          ),
        ),
      ),
    );
  }
}

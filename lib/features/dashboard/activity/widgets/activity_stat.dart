import 'package:flutter/material.dart';
import 'package:runca/ui/color.dart';
import 'package:runca/ui/typography.dart';

class ActivityStat extends StatelessWidget {
  const ActivityStat({required this.value, required this.label, super.key});

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

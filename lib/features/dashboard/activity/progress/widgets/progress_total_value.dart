import 'package:flutter/material.dart';
import 'package:runca/ui/color.dart';
import 'package:runca/ui/typography.dart';

class ProgressTotalValue extends StatelessWidget {
  const ProgressTotalValue({
    required this.value,
    required this.unit,
    super.key,
  });

  final String value;
  final String unit;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: value,
            style: AppTypography.displayLarge(
              color: AppPalette.textNeutralPrimary,
            ).copyWith(height: 1.2),
          ),
          TextSpan(
            text: ' $unit',
            style: AppTypography.displayLarge(
              color: AppPalette.textNeutralSecondary,
            ).copyWith(height: 1.2, fontWeight: AppTypography.semiBold),
          ),
        ],
      ),
      maxLines: 1,
    );
  }
}

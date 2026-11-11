import 'package:flutter/material.dart';

import 'package:runca/ui/color.dart';
import 'package:runca/ui/typography.dart';

/// Angka besar dan labelnya (Time atau Steps) di layar Treadmill.
class TreadmillMetric extends StatelessWidget {
  const TreadmillMetric({super.key, required this.value, required this.label});

  /// Tinggi blok angka; dipakai layar untuk menaruh blok di titik tengahnya.
  static const double valueHeight = 76;

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: valueHeight,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              maxLines: 1,
              style: AppTypography.headlineSmall(
                color: AppPalette.profileDarkText,
              ).copyWith(fontSize: 64, fontWeight: AppTypography.semiBold),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppTypography.bodyMedium(color: AppPalette.textNeutralPrimary),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

import 'package:runca/ui/color.dart';
import 'package:runca/ui/typography.dart';
import 'package:runca/utility/format_utils.dart';

/// Lingkaran dengan cincin biru dan angka hitung mundur.
class RunCountdownCircle extends StatelessWidget {
  const RunCountdownCircle({super.key, required this.number});

  static const double size = 206;

  final int number;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppPalette.bgSurfacePrimary.withValues(alpha: 0.100),
        border: Border.all(color: AppPalette.profileAccent, width: 8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            AppFormat.integer(number),
            style:
                AppTypography.headlineSmall(
                  color: AppPalette.profileDarkText,
                ).copyWith(
                  fontSize: 128,
                  fontWeight: AppTypography.semiBold,
                  height: 1,
                ),
          ),
        ),
      ),
    );
  }
}

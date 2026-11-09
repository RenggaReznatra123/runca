import 'package:flutter/material.dart';

import 'package:runca/ui/color.dart';
import 'package:runca/ui/typography.dart';

/// Chip status GPS. Hijau kalau teliti, oranye kalau lemah, abu kalau belum
/// ada sinyal.
class RunGpsChip extends StatelessWidget {
  const RunGpsChip({super.key, required this.accuracyMeters});

  /// Ketelitian GPS dalam meter. Null berarti belum ada sinyal.
  final double? accuracyMeters;

  // ASUMSI: batas teliti 20 meter (belum ada di Figma).
  static const double _goodAccuracyMeters = 20;

  @override
  Widget build(BuildContext context) {
    final accuracy = accuracyMeters;

    final color = accuracy == null
        ? AppPalette.textNeutralSecondary
        : accuracy <= _goodAccuracyMeters
        ? AppPalette.textSuccess
        : AppPalette.textWarning;

    return Container(
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppPalette.baseWhite,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppPalette.baseBlack.withValues(alpha: 0.08),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.signal_cellular_alt_rounded, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            'GPS',
            style: AppTypography.bodySmall(
              color: color,
            ).copyWith(fontSize: 13, fontWeight: AppTypography.semiBold),
          ),
        ],
      ),
    );
  }
}

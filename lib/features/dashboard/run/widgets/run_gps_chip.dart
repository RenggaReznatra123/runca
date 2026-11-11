import 'package:flutter/material.dart';

import 'package:runca/ui/color.dart';
import 'package:runca/ui/typography.dart';

/// Chip status GPS. Ikon dan warna mengikuti ketelitian: hijau 3 bar (bagus),
/// oranye 2 bar (agak jelek), merah 1 bar (jelek), abu kalau belum ada sinyal.
class RunGpsChip extends StatelessWidget {
  const RunGpsChip({super.key, required this.accuracyMeters});

  /// Ketelitian GPS dalam meter. Null berarti belum ada sinyal.
  final double? accuracyMeters;

  // ASUMSI: batas ketelitian (belum ada di Figma). Di atas 30 m, pembacaan
  // juga diabaikan untuk hitungan jarak (lihat RunTrackingCubit).
  static const double _goodAccuracyMeters = 15;
  static const double _fairAccuracyMeters = 30;

  @override
  Widget build(BuildContext context) {
    final (color, icon) = switch (accuracyMeters) {
      null => (
        AppPalette.textNeutralSecondary,
        Icons.signal_cellular_alt_rounded,
      ),
      <= _goodAccuracyMeters => (
        AppPalette.textSuccess,
        Icons.signal_cellular_alt_rounded,
      ),
      <= _fairAccuracyMeters => (
        AppPalette.textWarning,
        Icons.signal_cellular_alt_2_bar_rounded,
      ),
      _ => (
        AppPalette.textDanger,
        Icons.signal_cellular_alt_1_bar_rounded,
      ),
    };

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
          Icon(icon, size: 16, color: color),
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
import 'package:flutter/material.dart';

import 'package:runca/ui/color.dart';
import 'package:runca/ui/typography.dart';

/// Satu pilihan olahraga di sheet: ikon dan nama. Yang terpilih berwarna tosca.
class RunActivityTypeTile extends StatelessWidget {
  const RunActivityTypeTile({
    super.key,
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  static const double height = 78;

  @override
  Widget build(BuildContext context) {
    final foreground = selected
        ? AppPalette.baseWhite
        : AppPalette.textNeutralPrimary;

    return Material(
      color: selected ? AppPalette.profileAccent : AppPalette.bgSurfaceNeutral,
      borderRadius: BorderRadius.circular(12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: height,
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 26, color: foreground),
                const SizedBox(width: 12),
                Text(
                  label,
                  maxLines: 1,
                  style: AppTypography.bodyLarge(
                    color: foreground,
                  ).copyWith(fontWeight: AppTypography.medium),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
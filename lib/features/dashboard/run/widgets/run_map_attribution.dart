import 'package:flutter/material.dart';

import 'package:runca/config/map_config.dart';
import 'package:runca/ui/color.dart';
import 'package:runca/ui/typography.dart';

/// Tulisan sumber data peta (wajib untuk OpenStreetMap).
class RunMapAttribution extends StatelessWidget {
  const RunMapAttribution({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: AppPalette.baseWhite.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        MapConfig.attribution,
        style: AppTypography.bodySmall(
          color: AppPalette.textNeutralPrimary,
        ).copyWith(fontSize: 10),
      ),
    );
  }
}

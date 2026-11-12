import 'package:flutter/material.dart';

import 'package:runca/ui/color.dart';
import 'package:runca/ui/typography.dart';

import 'run_settings_row_text.dart';

/// Baris pengaturan dengan ikon, teks, nilai terpilih (biru), dan panah.
/// Ditekan untuk membuka sheet pilihan.
class RunSettingsChoiceRow extends StatelessWidget {
  const RunSettingsChoiceRow({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.onTap,
    this.subtitle,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final vertical = subtitle == null ? 16.0 : 12.0;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: vertical),
        child: Row(
          children: [
            Icon(icon, size: 24, color: AppPalette.iconNeutralPrimary),
            const SizedBox(width: 16),
            Expanded(
              child: RunSettingsRowText(title: title, subtitle: subtitle),
            ),
            const SizedBox(width: 12),
            Text(
              value,
              style: AppTypography.bodyLarge(color: AppPalette.profileAccent),
            ),
            const SizedBox(width: 6),
            const Icon(
              Icons.chevron_right_rounded,
              size: 24,
              color: AppPalette.profileMutedIcon,
            ),
          ],
        ),
      ),
    );
  }
}

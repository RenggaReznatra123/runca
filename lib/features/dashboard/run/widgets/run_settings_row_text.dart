import 'package:flutter/material.dart';

import 'package:runca/ui/color.dart';
import 'package:runca/ui/typography.dart';

/// Judul baris pengaturan dan teks kecil di bawahnya (opsional).
class RunSettingsRowText extends StatelessWidget {
  const RunSettingsRowText({super.key, required this.title, this.subtitle});

  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final sub = subtitle;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTypography.bodyLarge(
            color: AppPalette.textNeutralPrimary,
          ).copyWith(fontWeight: AppTypography.medium),
        ),
        if (sub != null) ...[
          const SizedBox(height: 4),
          Text(
            sub,
            style: AppTypography.bodySmall(color: AppPalette.profileMutedText),
          ),
        ],
      ],
    );
  }
}

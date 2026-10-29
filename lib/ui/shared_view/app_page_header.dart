import 'package:flutter/material.dart';

import 'package:runca/ui/color.dart';
import 'package:runca/ui/typography.dart';

/// Header halaman: tombol back dan judul (tinggi 56).
/// Garis pemisah di bawahnya ditambahkan oleh halaman yang memakainya.
class AppPageHeader extends StatelessWidget {
  const AppPageHeader({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            IconButton(
              onPressed: () => Navigator.of(context).maybePop(),
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
              iconSize: 20,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 28, minHeight: 44),
              color: AppPalette.textNeutralPrimary,
            ),
            const SizedBox(width: 4),
            Text(
              title,
              style: AppTypography.titleMedium(
                color: AppPalette.textNeutralPrimary,
              ).copyWith(fontWeight: AppTypography.medium),
            ),
          ],
        ),
      ),
    );
  }
}

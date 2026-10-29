import 'package:flutter/material.dart';

import 'package:runca/ui/color.dart';
import 'package:runca/ui/typography.dart';

/// Kartu "Still need help?" di bawah daftar FAQ.
class FaqSupportCard extends StatelessWidget {
  const FaqSupportCard({super.key, required this.onContactSupport});

  final VoidCallback onContactSupport;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppPalette.bgSurfaceNeutral,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppPalette.borderNeutral),
      ),
      child: Column(
        children: [
          const DecoratedBox(
            decoration: BoxDecoration(
              color: AppPalette.bgSurfacePrimary,
              shape: BoxShape.circle,
            ),
            child: SizedBox(
              width: 40,
              height: 40,
              child: Icon(
                Icons.chat_bubble_outline_rounded,
                size: 20,
                color: AppPalette.profileAccent,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Still need help?',
            style: AppTypography.bodyMedium(
              color: AppPalette.textNeutralPrimary,
            ).copyWith(fontWeight: AppTypography.semiBold, height: 20 / 14),
          ),
          const SizedBox(height: 2),
          Text(
            'Our customer support team is available 24/7 to resolve your '
            'running tracking queries.',
            textAlign: TextAlign.center,
            style: AppTypography.bodySmall(
              color: AppPalette.profileMutedText,
            ).copyWith(height: 20 / 12),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 38,
            child: ElevatedButton(
              onPressed: onContactSupport,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppPalette.profileAccent,
                foregroundColor: AppPalette.baseWhite,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text('Contact Support', style: AppTypography.titleSmall()),
            ),
          ),
        ],
      ),
    );
  }
}

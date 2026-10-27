import 'package:flutter/material.dart';

import 'package:runca/ui/color.dart';
import 'package:runca/ui/typography.dart';

/// Kartu "Applicable Outlets".
class VoucherOutletCard extends StatelessWidget {
  const VoucherOutletCard({super.key, required this.outlet});

  final String outlet;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(
        color: AppPalette.baseWhite,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.storefront_outlined,
            size: 24,
            color: AppPalette.iconNeutralPrimary,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Applicable Outlets',
                  style: AppTypography.bodySmall(
                    color: AppPalette.profileMutedText,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  outlet,
                  style: AppTypography.bodyMedium(
                    color: AppPalette.textNeutralPrimary,
                  ).copyWith(fontWeight: AppTypography.medium),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

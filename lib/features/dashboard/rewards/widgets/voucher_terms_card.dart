import 'package:flutter/material.dart';

import 'package:runca/ui/color.dart';
import 'package:runca/ui/typography.dart';

/// Kartu "How to Use & Terms" dengan daftar bernomor.
class VoucherTermsCard extends StatelessWidget {
  const VoucherTermsCard({super.key, required this.terms});

  final List<String> terms;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppPalette.baseWhite,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'How to Use & Terms',
            style: AppTypography.titleSmall(
              color: AppPalette.textNeutralPrimary,
            ).copyWith(fontWeight: AppTypography.semiBold),
          ),
          const SizedBox(height: 16),
          for (var i = 0; i < terms.length; i++)
            Padding(
              padding: EdgeInsets.only(bottom: i == terms.length - 1 ? 0 : 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 18,
                    child: Text(
                      '${i + 1}.',
                      style: AppTypography.bodySmall(
                        color: AppPalette.textNeutralPrimary,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      terms[i],
                      style: AppTypography.bodySmall(
                        color: AppPalette.textNeutralPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

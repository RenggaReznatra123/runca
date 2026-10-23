import 'package:flutter/material.dart';
import 'package:runca/config/app_assets.dart';
import 'package:runca/ui/color.dart';
import 'package:runca/ui/typography.dart';

class ChallengeRewardRow extends StatelessWidget {
  const ChallengeRewardRow({super.key, required this.amount});

  /// Jumlah hadiah yang sudah diformat, contoh: '5,000'.
  final String amount;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(AppAssets.placoin, width: 24, height: 24),
        const SizedBox(width: 8),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: '+ $amount',
                style: AppTypography.titleMedium(
                  color: AppPalette.textNeutralPrimary,
                ).copyWith(fontSize: 16),
              ),
              TextSpan(
                text: ' PlaCoins',
                style: AppTypography.bodyMedium(
                  color: AppPalette.textNeutralSecondary,
                ).copyWith(fontSize: 13),
              ),
            ],
          ),
          maxLines: 1,
        ),
      ],
    );
  }
}

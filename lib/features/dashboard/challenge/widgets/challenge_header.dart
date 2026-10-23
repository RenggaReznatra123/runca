import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:runca/config/app_assets.dart';
import 'package:runca/ui/color.dart';
import 'package:runca/ui/typography.dart';

class ChallengeHeader extends StatelessWidget {
  const ChallengeHeader({super.key, required this.coinBalance});

  final int coinBalance;

  @override
  Widget build(BuildContext context) {
    // Padding dan tinggi dibuat sama dengan ActivityHeader.
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: SizedBox(
        height: 48,
        child: Row(
          children: [
            Expanded(
              child: Text(
                'Challenges',
                style: AppTypography.titleLarge(
                  color: AppPalette.textNeutralPrimary,
                ),
              ),
            ),
            _CoinBalancePill(balance: coinBalance),
          ],
        ),
      ),
    );
  }
}

class _CoinBalancePill extends StatelessWidget {
  const _CoinBalancePill({required this.balance});

  final int balance;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      padding: const EdgeInsets.fromLTRB(12, 0, 10, 0),
      decoration: BoxDecoration(
        color: AppPalette.baseWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppPalette.borderNeutral),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            AppAssets.placoin,
            width: 18,
            height: 18,
            fit: BoxFit.contain,
          ),
          const SizedBox(width: 8),
          Text(
            NumberFormat('#,###').format(balance),
            style: AppTypography.bodyMedium(
              color: AppPalette.textNeutralPrimary,
            ).copyWith(fontSize: 13, fontWeight: AppTypography.medium),
          ),
          const SizedBox(width: 6),
          const Icon(
            Icons.chevron_right_rounded,
            size: 18,
            color: AppPalette.textNeutralSecondary,
          ),
        ],
      ),
    );
  }
}

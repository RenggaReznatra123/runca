import 'package:flutter/material.dart';
import 'package:runca/config/app_assets.dart';
import 'package:runca/ui/color.dart';
import 'package:runca/ui/typography.dart';
import 'package:runca/utility/format_utils.dart';

class ChallengeHeader extends StatelessWidget {
  const ChallengeHeader({
    super.key,
    required this.coinBalance,
    required this.onCoinTap,
  });

  final int coinBalance;
  final VoidCallback onCoinTap;

  @override
  Widget build(BuildContext context) {
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
            _CoinBalancePill(balance: coinBalance, onTap: onCoinTap),
          ],
        ),
      ),
    );
  }
}

class _CoinBalancePill extends StatelessWidget {
  const _CoinBalancePill({required this.balance, required this.onTap});

  final int balance;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppPalette.baseWhite,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          height: 40,
          padding: const EdgeInsets.fromLTRB(14, 0, 12, 0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppPalette.borderNeutral),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                AppAssets.placoin,
                width: 24,
                height: 24,
                fit: BoxFit.contain,
              ),
              const SizedBox(width: 10),
              Text(
                AppFormat.thousands(balance),
                style: AppTypography.bodyMedium(
                  color: AppPalette.textNeutralPrimary,
                ).copyWith(fontSize: 16, fontWeight: AppTypography.medium),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.chevron_right_rounded,
                size: 20,
                color: AppPalette.textNeutralSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

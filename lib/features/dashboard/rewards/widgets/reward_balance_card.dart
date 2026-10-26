import 'package:flutter/material.dart';

import 'package:runca/config/app_assets.dart';
import 'package:runca/ui/color.dart';
import 'package:runca/utility/format_utils.dart';

/// Kartu saldo PlaCoins di bagian atas halaman Rewards.
class RewardBalanceCard extends StatelessWidget {
  const RewardBalanceCard({
    super.key,
    required this.balance,
    required this.onHistoryTap,
    required this.onHowToEarnTap,
  });

  final int balance;
  final VoidCallback onHistoryTap;
  final VoidCallback onHowToEarnTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(22, 24, 22, 22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppPalette.bgFillPrimary, AppPalette.bgButtonPrimaryHover],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Your PlaCoins',
            style: TextStyle(fontSize: 16, color: AppPalette.textWhitePrimary),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Image.asset(AppAssets.placoin, width: 38, height: 38),
              const SizedBox(width: 18),
              Flexible(
                child: Text(
                  AppFormat.thousands(balance),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w600,
                    color: AppPalette.textWhitePrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 26),
          Row(
            children: [
              Expanded(
                child: _BalanceAction(
                  label: 'PlaCoins History',
                  onTap: onHistoryTap,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _BalanceAction(
                  label: 'How to Earn',
                  onTap: onHowToEarnTap,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BalanceAction extends StatelessWidget {
  const _BalanceAction({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppPalette.baseWhite.withValues(alpha: 0.16),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppPalette.textWhitePrimary,
                  ),
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppPalette.textWhitePrimary,
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

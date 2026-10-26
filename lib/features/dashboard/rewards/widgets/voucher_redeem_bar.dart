import 'package:flutter/material.dart';

import 'package:runca/ui/color.dart';

import 'insufficient_balance_card.dart';
import 'reward_balance_summary.dart';

/// Bagian bawah halaman detail voucher: ringkasan saldo dan tombol Redeem.
class VoucherRedeemBar extends StatelessWidget {
  const VoucherRedeemBar({
    super.key,
    required this.price,
    required this.balance,
    required this.isRedeeming,
    required this.onRedeem,
  });

  final int price;
  final int balance;
  final bool isRedeeming;
  final VoidCallback onRedeem;

  @override
  Widget build(BuildContext context) {
    final hasEnoughCoins = balance >= price;

    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
        color: AppPalette.baseWhite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!hasEnoughCoins) ...[
              InsufficientBalanceCard(
                requiredCoins: price,
                currentBalance: balance,
              ),
              const SizedBox(height: 12),
            ],
            RewardBalanceSummary(price: price, balance: balance),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: isRedeeming || !hasEnoughCoins ? null : onRedeem,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppPalette.bgFillPrimary,
                  foregroundColor: AppPalette.baseWhite,
                  disabledBackgroundColor: AppPalette.bgFillPrimary.withValues(
                    alpha: 0.35,
                  ),
                  disabledForegroundColor: AppPalette.textWhiteSecondary,
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: isRedeeming
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppPalette.baseWhite,
                        ),
                      )
                    : const Text(
                        'Redeem Now',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

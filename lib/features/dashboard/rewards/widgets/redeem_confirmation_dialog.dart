import 'package:flutter/material.dart';

import 'package:runca/ui/color.dart';
import 'package:runca/utility/format_utils.dart';

class RedeemConfirmationDialog extends StatelessWidget {
  const RedeemConfirmationDialog({
    super.key,
    required this.rewardTitle,
    required this.brandName,
    required this.price,
    required this.balance,
  });

  final String rewardTitle;
  final String brandName;
  final int price;
  final int balance;

  /// Mengembalikan true kalau pengguna menekan Redeem.
  static Future<bool> show(
    BuildContext context, {
    required String rewardTitle,
    required String brandName,
    required int price,
    required int balance,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (_) => RedeemConfirmationDialog(
        rewardTitle: rewardTitle,
        brandName: brandName,
        price: price,
        balance: balance,
      ),
    );

    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final remainingBalance = balance - price;

    return Dialog(
      backgroundColor: AppPalette.baseWhite,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(22, 28, 22, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Redeem Reward?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: AppPalette.textNeutralPrimary,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Redeem ${AppFormat.thousands(price)} PC for $rewardTitle '
              '($brandName)? Your remaining balance will be '
              '${AppFormat.thousands(remainingBalance)} PC.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                height: 1.55,
                color: AppPalette.textNeutralSecondary,
              ),
            ),
            const SizedBox(height: 26),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 54,
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppPalette.textNeutralPrimary,
                        side: const BorderSide(
                          color: AppPalette.borderButtonOutlinedDefault,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(fontSize: 17),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SizedBox(
                    height: 54,
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppPalette.bgFillPrimary,
                        foregroundColor: AppPalette.baseWhite,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      child: const Text(
                        'Redeem',
                        style: TextStyle(fontSize: 17),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
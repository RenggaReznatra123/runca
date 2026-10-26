import 'package:flutter/material.dart';

import 'package:runca/ui/color.dart';
import 'package:runca/utility/format_utils.dart';

class InsufficientBalanceCard extends StatelessWidget {
  const InsufficientBalanceCard({
    super.key,
    required this.requiredCoins,
    required this.currentBalance,
  });

  final int requiredCoins;
  final int currentBalance;

  @override
  Widget build(BuildContext context) {
    final shortage = requiredCoins - currentBalance;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppPalette.bgSurfaceDanger,
        border: Border.all(
          color: AppPalette.borderDanger.withValues(alpha: 0.3),
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: AppPalette.textDanger,
            size: 22,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Not enough PlaCoins',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppPalette.textDanger,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'You need ${AppFormat.thousands(shortage)} more PlaCoins '
                  'to redeem this voucher.',
                  style: const TextStyle(
                    fontSize: 13,
                    height: 1.5,
                    color: AppPalette.textNeutralPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Required: ${AppFormat.thousands(requiredCoins)} PC \u00b7 '
                  'Available: ${AppFormat.thousands(currentBalance)} PC',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppPalette.textNeutralPrimary,
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
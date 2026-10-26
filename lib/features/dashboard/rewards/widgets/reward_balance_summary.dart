import 'package:flutter/material.dart';

import 'package:runca/config/app_assets.dart';
import 'package:runca/ui/color.dart';
import 'package:runca/utility/format_utils.dart';

class RewardBalanceSummary extends StatelessWidget {
  const RewardBalanceSummary({
    super.key,
    required this.price,
    required this.balance,
  });

  final int price;
  final int balance;

  @override
  Widget build(BuildContext context) {
    final sufficient = balance >= price;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _BalanceColumn(
            label: 'PlaCoins cost',
            value: AppFormat.thousands(price),
            valueColor: AppPalette.textNeutralPrimary,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _BalanceColumn(
            label: 'Your balance',
            value: AppFormat.thousands(balance),
            valueColor: sufficient
                ? AppPalette.textSuccess
                : AppPalette.textDanger,
            alignEnd: true,
          ),
        ),
      ],
    );
  }
}

class _BalanceColumn extends StatelessWidget {
  const _BalanceColumn({
    required this.label,
    required this.value,
    required this.valueColor,
    this.alignEnd = false,
  });

  final String label;
  final String value;
  final Color valueColor;
  final bool alignEnd;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignEnd
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            color: AppPalette.textNeutralPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: alignEnd
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          children: [
            Image.asset(
              AppAssets.placoin,
              width: 28,
              height: 28,
              fit: BoxFit.contain,
              errorBuilder: (_, _, _) => const Icon(
                Icons.monetization_on_outlined,
                size: 28,
                color: AppPalette.textWarning,
              ),
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: valueColor,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
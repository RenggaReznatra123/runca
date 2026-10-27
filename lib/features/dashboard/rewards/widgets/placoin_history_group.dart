import 'package:flutter/material.dart';

import 'package:runca/ui/color.dart';
import 'package:runca/ui/typography.dart';
import 'package:runca/utility/format_utils.dart';

import '../models/placoin_transaction_model.dart';
import 'placoin_history_item.dart';

/// Satu grup tanggal: label tanggal, transaksi, lalu garis pemisah.
class PlaCoinHistoryGroup extends StatelessWidget {
  const PlaCoinHistoryGroup({
    super.key,
    required this.date,
    required this.transactions,
  });

  final DateTime date;
  final List<PlaCoinTransaction> transactions;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppFormat.shortDate(date),
          style: AppTypography.bodyMedium(color: AppPalette.profileMutedText),
        ),
        const SizedBox(height: 14),
        for (var i = 0; i < transactions.length; i++) ...[
          if (i > 0) const SizedBox(height: 28),
          PlaCoinHistoryItem(transaction: transactions[i]),
        ],
        const SizedBox(height: 24),
        const Divider(height: 1, thickness: 1, color: AppPalette.borderNeutral),
        const SizedBox(height: 12),
      ],
    );
  }
}
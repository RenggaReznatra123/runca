import 'package:flutter/material.dart';

import 'package:runca/ui/color.dart';
import 'package:runca/ui/shared_view/app_image.dart';
import 'package:runca/ui/typography.dart';
import 'package:runca/utility/format_utils.dart';

import '../models/placoin_transaction_model.dart';

/// Satu baris transaksi: ikon, judul, jam, dan jumlah koin.
class PlaCoinHistoryItem extends StatelessWidget {
  const PlaCoinHistoryItem({super.key, required this.transaction});

  final PlaCoinTransaction transaction;

  @override
  Widget build(BuildContext context) {
    final isEarned = transaction.amount > 0;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: AppImage(path: transaction.imageUrl, width: 48, height: 48),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(
                  transaction.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.titleSmall(
                    color: AppPalette.textNeutralPrimary,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                AppFormat.timeOfDay(transaction.createdAt),
                style: AppTypography.bodyMedium(
                  color: AppPalette.profileMutedText,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Text(
          AppFormat.coinAmount(transaction.amount),
          maxLines: 1,
          style: AppTypography.titleSmall(
            color: isEarned ? AppPalette.textSuccess : AppPalette.textDanger,
          ),
        ),
      ],
    );
  }
}

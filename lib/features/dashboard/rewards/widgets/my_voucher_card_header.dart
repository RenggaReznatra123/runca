import 'package:flutter/material.dart';
import 'package:runca/ui/color.dart';
import 'package:runca/ui/shared_view/app_image.dart';
import 'package:runca/ui/typography.dart';

import '../models/my_voucher_model.dart';

class MyVoucherCardHeader extends StatelessWidget {
  const MyVoucherCardHeader({required this.voucher, super.key});

  final MyVoucherSummary voucher;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: AppImage(path: voucher.imageUrl, width: 103, height: 87),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppPalette.bgSurfaceNeutral,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  voucher.category.label,
                  style: AppTypography.bodySmall(
                    color: AppPalette.profileMutedText,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                voucher.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.titleMedium(
                  color: AppPalette.textNeutralPrimary,
                ).copyWith(fontWeight: AppTypography.medium),
              ),
              const SizedBox(height: 4),
              Text(
                voucher.brandName,
                style: AppTypography.bodyMedium(
                  color: AppPalette.profileMutedText,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

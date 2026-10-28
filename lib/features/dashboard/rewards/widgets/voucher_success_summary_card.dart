import 'package:flutter/material.dart';
import 'package:runca/ui/color.dart';
import 'package:runca/ui/shared_view/app_image.dart';

import '../models/reward_model.dart';

class VoucherSuccessSummaryCard extends StatelessWidget {
  const VoucherSuccessSummaryCard({required this.detail, super.key});

  final RewardDetail detail;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppPalette.baseWhite,
        border: Border.all(color: AppPalette.borderNeutral, width: 1.2),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: AppImage(path: detail.imageUrl, width: 112, height: 112),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppPalette.bgSurfaceNeutral,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    detail.category.label,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppPalette.textNeutralSecondary,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  detail.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 17,
                    height: 1.25,
                    fontWeight: FontWeight.w500,
                    color: AppPalette.textNeutralPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  detail.brandName,
                  style: const TextStyle(
                    fontSize: 14,
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

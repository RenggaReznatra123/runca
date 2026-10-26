import 'package:flutter/material.dart';

import 'package:runca/ui/color.dart';
import 'package:runca/ui/shared_view/app_image.dart';
import 'package:runca/utility/format_utils.dart';

import '../models/reward_model.dart';
import 'voucher_info_item.dart';

/// Isi halaman detail voucher (bagian yang di-scroll).
class VoucherDetailContent extends StatelessWidget {
  const VoucherDetailContent({super.key, required this.detail});

  final RewardDetail detail;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: AspectRatio(
              aspectRatio: 2.1,
              child: AppImage(path: detail.imageUrl, width: double.infinity),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              SizedBox(
                width: 56,
                height: 52,
                child: AppImage(
                  path: detail.brandLogoUrl,
                  fit: BoxFit.contain,
                  placeholder: const Icon(
                    Icons.storefront_outlined,
                    size: 28,
                    color: AppPalette.textNeutralSecondary,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      detail.brandName,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: AppPalette.textNeutralPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      detail.category.label,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppPalette.textNeutralSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            detail.title,
            style: const TextStyle(
              fontSize: 28,
              height: 1.2,
              fontWeight: FontWeight.w600,
              color: AppPalette.textNeutralPrimary,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            detail.description,
            style: const TextStyle(
              fontSize: 14,
              height: 1.45,
              color: AppPalette.textNeutralPrimary,
            ),
          ),
          const SizedBox(height: 20),
          VoucherInfoItem(
            icon: Icons.calendar_month_outlined,
            label: 'Valid until',
            value: AppFormat.shortDate(detail.validUntil),
          ),
          VoucherInfoItem(
            icon: Icons.storefront_outlined,
            label: 'Available at',
            value: detail.availableAt,
          ),
          VoucherInfoItem(
            icon: Icons.confirmation_num_outlined,
            label: 'Quota left',
            value: AppFormat.voucherCount(detail.quotaLeft),
          ),
        ],
      ),
    );
  }
}

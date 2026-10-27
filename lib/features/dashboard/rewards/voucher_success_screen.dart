import 'package:flutter/material.dart';

import 'package:runca/config/app_assets.dart';
import 'package:runca/ui/color.dart';
import 'package:runca/ui/shared_view/app_image.dart';
import 'models/reward_model.dart';
import 'my_voucher_detail_screen.dart';

class VoucherSuccessScreen extends StatelessWidget {
  const VoucherSuccessScreen({
    super.key,
    required this.detail,
    required this.voucherId,
  });

  final RewardDetail detail;
  final String voucherId;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPalette.baseWhite,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 390,
                      child: Image.asset(
                        AppAssets.successIllustration,
                        fit: BoxFit.contain,
                        errorBuilder: (_, _, _) => const Center(
                          child: Icon(
                            Icons.check_circle,
                            size: 180,
                            color: AppPalette.textSuccess,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Voucher Redeemed!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 30,
                        height: 1.2,
                        fontWeight: FontWeight.w600,
                        color: AppPalette.textNeutralPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Your voucher is saved in My Vouchers.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.4,
                        color: AppPalette.textNeutralSecondary,
                      ),
                    ),
                    const SizedBox(height: 28),
                    _VoucherSummaryCard(detail: detail),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) =>
                                MyVoucherDetailScreen(voucherId: voucherId),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppPalette.bgFillPrimary,
                        foregroundColor: AppPalette.baseWhite,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        'View Voucher',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppPalette.textNeutralPrimary,
                        side: const BorderSide(
                          color: AppPalette.borderButtonOutlinedDefault,
                          width: 1.4,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        'Back to Rewards',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VoucherSummaryCard extends StatelessWidget {
  const _VoucherSummaryCard({required this.detail});

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

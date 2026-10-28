import 'package:flutter/material.dart';

import 'package:runca/config/app_assets.dart';
import 'package:runca/ui/color.dart';
import 'package:runca/ui/typography.dart';

import '../models/my_voucher_model.dart';

/// Tampilan saat tab voucher masih kosong.
class MyVouchersEmptyView extends StatelessWidget {
  const MyVouchersEmptyView({
    super.key,
    required this.status,
    required this.onExploreRewards,
  });

  final VoucherStatus status;
  final VoidCallback onExploreRewards;

  @override
  Widget build(BuildContext context) {
    // ASUMSI: teks Used dan Expired belum ada di Figma.
    final (title, message) = switch (status) {
      VoucherStatus.active => (
        'No Active Vouchers Yet',
        'Your rewards are waiting! Redeem your points for exciting deals '
            'and find your vouchers here.',
      ),
      VoucherStatus.used => (
        'No Used Vouchers Yet',
        'Vouchers you have used will appear here.',
      ),
      VoucherStatus.expired => (
        'No Expired Vouchers',
        'Vouchers that have passed their valid date will appear here.',
      ),
    };

    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 68, 20, 24),
      child: Column(
        children: [
          const SizedBox(width: 144, height: 88, child: _Illustration()),
          const SizedBox(height: 44),
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppTypography.titleLarge(
              color: AppPalette.textNeutralPrimary,
            ).copyWith(fontSize: 20),
          ),
          const SizedBox(height: 12),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 320),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: AppTypography.bodyMedium(
                color: AppPalette.profileMutedText,
              ).copyWith(height: 24 / 14),
            ),
          ),
          // Tombol hanya ada di tab Active (sesuai Figma).
          if (status == VoucherStatus.active) ...[
            const SizedBox(height: 24),
            OutlinedButton(
              onPressed: onExploreRewards,
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(0, 38),
                padding: const EdgeInsets.symmetric(horizontal: 14),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                foregroundColor: AppPalette.textButtonOutlined,
                side: const BorderSide(
                  color: AppPalette.borderButtonOutlinedDefault,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Explore Rewards',
                style: AppTypography.titleSmall().copyWith(
                  fontWeight: AppTypography.regular,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _Illustration extends StatelessWidget {
  const _Illustration();

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      AppAssets.voucherEmpty,
      fit: BoxFit.contain,
      errorBuilder: (_, _, _) => const Center(
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: AppPalette.bgSurfacePrimary,
            shape: BoxShape.circle,
          ),
          child: SizedBox(
            width: 88,
            height: 88,
            child: Icon(
              Icons.confirmation_number_outlined,
              size: 40,
              color: AppPalette.bgFillPrimary,
            ),
          ),
        ),
      ),
    );
  }
}

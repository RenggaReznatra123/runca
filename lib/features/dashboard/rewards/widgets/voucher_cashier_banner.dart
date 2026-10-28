import 'package:flutter/material.dart';

import 'package:runca/ui/color.dart';
import 'package:runca/ui/typography.dart';

/// Banner "Show your vouchers at the cashier" di bawah daftar voucher aktif.
class VoucherCashierBanner extends StatelessWidget {
  const VoucherCashierBanner({super.key});

  // ASUMSI: warna biru muda memakai token yang sudah ada (hex Figma belum ada).
  static const Color _accent = AppPalette.iconTextIconSecondaryDefault;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 78,
      padding: const EdgeInsets.fromLTRB(18, 0, 19, 0),
      decoration: BoxDecoration(
        color: AppPalette.bgSurfacePrimary,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _accent),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline_rounded, size: 22, color: _accent),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Show your vouchers at the cashier',
                  style: AppTypography.bodyMedium(
                    color: AppPalette.textNeutralPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Don\'t forget to bring your phone!',
                  style: AppTypography.bodySmall(
                    color: AppPalette.profileMutedText,
                  ),
                ),
              ],
            ),
          ),
          Transform.rotate(
            angle: 0.17,
            child: const Icon(
              Icons.smartphone_outlined,
              size: 40,
              color: _accent,
            ),
          ),
        ],
      ),
    );
  }
}

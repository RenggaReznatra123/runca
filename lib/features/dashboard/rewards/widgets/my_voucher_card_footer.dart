import 'package:flutter/material.dart';
import 'package:runca/ui/color.dart';
import 'package:runca/ui/typography.dart';
import 'package:runca/utility/format_utils.dart';

import '../models/my_voucher_model.dart';

class MyVoucherCardFooter extends StatelessWidget {
  const MyVoucherCardFooter({required this.voucher, super.key});

  final MyVoucherSummary voucher;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Valid until ${AppFormat.shortDate(voucher.validUntil)}',
          style: AppTypography.bodySmall(color: AppPalette.profileMutedText),
        ),
        _StatusBadge(status: voucher.status),
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final VoucherStatus status;

  @override
  Widget build(BuildContext context) {
    final (background, foreground) = switch (status) {
      VoucherStatus.active => (
        AppPalette.bgSurfaceSuccess,
        AppPalette.textSuccess,
      ),
      VoucherStatus.used => (
        AppPalette.bgSurfaceNeutral,
        AppPalette.textNeutralSecondary,
      ),
      VoucherStatus.expired => (
        AppPalette.bgSurfaceDanger,
        AppPalette.textDanger,
      ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        status.label,
        style: AppTypography.bodySmall(color: foreground),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:runca/ui/color.dart';
import 'package:runca/ui/typography.dart';

class VoucherScanHint extends StatelessWidget {
  const VoucherScanHint({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.qr_code_scanner_rounded,
          size: 22,
          color: AppPalette.profileMutedIcon,
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            'Show this QR code or voucher code to cashier before payment',
            textAlign: TextAlign.center,
            style: AppTypography.bodySmall(color: AppPalette.profileMutedText),
          ),
        ),
      ],
    );
  }
}

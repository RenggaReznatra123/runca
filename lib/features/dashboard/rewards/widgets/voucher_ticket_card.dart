import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'package:runca/ui/color.dart';
import 'package:runca/ui/typography.dart';
import 'package:runca/utility/format_utils.dart';

import '../models/reward_model.dart';
import 'dashed_line_painter.dart';
import 'voucher_code_box.dart';
import 'voucher_scan_hint.dart';
import 'voucher_ticket_header.dart';

/// Kartu tiket voucher: info brand, QR code, kode, dan petunjuk.
///
/// Lekukan di sisi garis putus-putus digambar dengan warna [pageColor],
/// jadi halaman yang memakai kartu ini harus berlatar warna yang sama.
class VoucherTicketCard extends StatelessWidget {
  const VoucherTicketCard({
    super.key,
    required this.voucher,
    required this.onCopyCode,
  });

  final RedeemedVoucher voucher;
  final VoidCallback onCopyCode;

  static const Color pageColor = AppPalette.bgSurfaceNeutral;

  static const double _radius = 20;
  static const double _qrSize = 186;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppPalette.baseWhite,
        borderRadius: BorderRadius.circular(_radius),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: VoucherTicketHeader(voucher: voucher),
          ),
          const _TicketDivider(),
          const SizedBox(height: 25),
          QrImageView(
            data: voucher.qrData,
            size: _qrSize,
            padding: EdgeInsets.zero,
            backgroundColor: AppPalette.baseWhite,
            eyeStyle: const QrEyeStyle(
              eyeShape: QrEyeShape.square,
              color: AppPalette.baseBlack,
            ),
            dataModuleStyle: const QrDataModuleStyle(
              dataModuleShape: QrDataModuleShape.square,
              color: AppPalette.baseBlack,
            ),
          ),
          const SizedBox(height: 27),
          VoucherCodeBox(code: voucher.code, onCopy: onCopyCode),
          const SizedBox(height: 16),
          Text(
            'Valid until ${AppFormat.shortDate(voucher.validUntil)}',
            style: AppTypography.bodySmall(color: AppPalette.profileMutedText),
          ),
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: VoucherScanHint(),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

/// Garis putus-putus dengan lekukan setengah lingkaran di kiri dan kanan.
class _TicketDivider extends StatelessWidget {
  const _TicketDivider();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          const Positioned.fill(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 18),
              child: CustomPaint(
                painter: DashedLinePainter(color: AppPalette.borderNeutral),
              ),
            ),
          ),
          const Positioned(left: -10, top: 0, child: _Notch()),
          const Positioned(right: -10, top: 0, child: _Notch()),
        ],
      ),
    );
  }
}

class _Notch extends StatelessWidget {
  const _Notch();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 20,
      height: 20,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: VoucherTicketCard.pageColor,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

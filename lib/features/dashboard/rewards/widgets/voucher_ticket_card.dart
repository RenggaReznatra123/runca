import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'package:runca/ui/color.dart';
import 'package:runca/ui/shared_view/app_image.dart';
import 'package:runca/ui/typography.dart';
import 'package:runca/utility/format_utils.dart';

import '../models/reward_model.dart';
import 'voucher_code_box.dart';

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
            child: _TicketHeader(voucher: voucher),
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
            child: _ScanHint(),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _TicketHeader extends StatelessWidget {
  const _TicketHeader({required this.voucher});

  final RedeemedVoucher voucher;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: AppImage(path: voucher.imageUrl, width: 86, height: 68),
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
                painter: _DashedLinePainter(color: AppPalette.borderNeutral),
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

class _DashedLinePainter extends CustomPainter {
  const _DashedLinePainter({required this.color});

  final Color color;

  static const double _dashWidth = 7;
  static const double _dashGap = 4;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final y = size.height / 2;
    var x = 0.0;

    while (x < size.width) {
      canvas.drawLine(
        Offset(x, y),
        Offset(math.min(x + _dashWidth, size.width), y),
        paint,
      );
      x += _dashWidth + _dashGap;
    }
  }

  @override
  bool shouldRepaint(_DashedLinePainter oldDelegate) =>
      oldDelegate.color != color;
}

class _ScanHint extends StatelessWidget {
  const _ScanHint();

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

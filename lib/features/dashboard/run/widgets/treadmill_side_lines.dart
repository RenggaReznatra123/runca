import 'package:flutter/material.dart';

import 'package:runca/ui/color.dart';

/// Dua garis miring dekoratif di kiri dan kanan angka layar Treadmill.
class TreadmillSideLines extends StatelessWidget {
  const TreadmillSideLines({super.key});

  static const double height = 256;

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: double.infinity,
      height: height,
      child: CustomPaint(painter: _SideLinesPainter()),
    );
  }
}

class _SideLinesPainter extends CustomPainter {
  const _SideLinesPainter();

  static const double _stroke = 8;

  @override
  void paint(Canvas canvas, Size size) {
    final top = _stroke / 2;
    final bottom = size.height - _stroke / 2;

    // Posisi x dari Figma (frame lebar 412): atas lebih ke tengah, bawah
    // lebih ke tepi.
    _line(
      canvas,
      Offset(size.width * 0.18, top),
      Offset(size.width * 0.053, bottom),
    );
    _line(
      canvas,
      Offset(size.width * 0.82, top),
      Offset(size.width * 0.947, bottom),
    );
  }

  void _line(Canvas canvas, Offset from, Offset to) {
    final paint = Paint()
      ..strokeWidth = _stroke
      ..strokeCap = StrokeCap.round
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppPalette.profileDisabledFill.withValues(alpha: 0.4),
          AppPalette.profileSoftBorder,
        ],
      ).createShader(Rect.fromPoints(from, to));

    canvas.drawLine(from, to, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

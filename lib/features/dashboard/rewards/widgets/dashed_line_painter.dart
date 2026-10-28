import 'dart:math' as math;

import 'package:flutter/material.dart';

class DashedLinePainter extends CustomPainter {
  const DashedLinePainter({required this.color});

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
  bool shouldRepaint(DashedLinePainter oldDelegate) =>
      oldDelegate.color != color;
}

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:runca/ui/color.dart';

import 'dashed_line_painter.dart';

class MyVoucherTicketDivider extends StatelessWidget {
  const MyVoucherTicketDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 20,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 26),
              child: CustomPaint(
                painter: DashedLinePainter(color: AppPalette.borderNeutral),
              ),
            ),
          ),
          Positioned(left: -1, top: 0, child: _Notch(isLeft: true)),
          Positioned(right: -1, top: 0, child: _Notch(isLeft: false)),
        ],
      ),
    );
  }
}

class _Notch extends StatelessWidget {
  const _Notch({required this.isLeft});

  final bool isLeft;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 10,
      height: 20,
      child: CustomPaint(painter: _NotchPainter(isLeft: isLeft)),
    );
  }
}

class _NotchPainter extends CustomPainter {
  const _NotchPainter({required this.isLeft});

  final bool isLeft;

  @override
  void paint(Canvas canvas, Size size) {
    final radius = size.height / 2;
    final center = Offset(isLeft ? 0 : size.width, radius);
    final rect = Rect.fromCircle(center: center, radius: radius);
    final startAngle = isLeft ? -math.pi / 2 : math.pi / 2;

    final fill = Path()
      ..moveTo(center.dx, center.dy)
      ..arcTo(rect, startAngle, math.pi, false)
      ..close();

    canvas.drawPath(fill, Paint()..color = AppPalette.baseWhite);

    canvas.drawArc(
      rect,
      startAngle,
      math.pi,
      false,
      Paint()
        ..color = AppPalette.borderNeutral
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );
  }

  @override
  bool shouldRepaint(_NotchPainter oldDelegate) => oldDelegate.isLeft != isLeft;
}

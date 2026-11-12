import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:runca/ui/color.dart';

/// Tombol bulat bercincin yang harus ditahan sampai penuh baru berfungsi,
/// supaya tidak tertekan tidak sengaja. Isinya terisi dari bawah.
class TreadmillHoldButton extends StatefulWidget {
  const TreadmillHoldButton({
    super.key,
    required this.icon,
    required this.iconSize,
    required this.color,
    required this.ringWidth,
    required this.holdDuration,
    required this.onCompleted,
  });

  final IconData icon;
  final double iconSize;
  final Color color;
  final double ringWidth;
  final Duration holdDuration;
  final VoidCallback onCompleted;

  @override
  State<TreadmillHoldButton> createState() => _TreadmillHoldButtonState();
}

class _TreadmillHoldButtonState extends State<TreadmillHoldButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.holdDuration,
    )..addStatusListener(_onStatus);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onStatus(AnimationStatus status) {
    if (status != AnimationStatus.completed) return;

    HapticFeedback.mediumImpact();
    widget.onCompleted();

    // Kembali ke awal supaya bisa ditahan lagi.
    if (mounted) _controller.reset();
  }

  void _startHold() => _controller.forward();

  void _cancelHold() {
    if (_controller.status != AnimationStatus.completed) _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _startHold(),
      onTapUp: (_) => _cancelHold(),
      onTapCancel: _cancelHold,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: widget.color.withValues(alpha: 0.5),
            width: widget.ringWidth,
          ),
        ),
        child: ClipOval(
          child: Stack(
            fit: StackFit.expand,
            children: [
              ColoredBox(color: widget.color),
              AnimatedBuilder(
                animation: _controller,
                builder: (context, _) => Align(
                  alignment: Alignment.bottomCenter,
                  child: FractionallySizedBox(
                    widthFactor: 1,
                    heightFactor: _controller.value,
                    child: ColoredBox(
                      color: AppPalette.baseBlack.withValues(alpha: 0.18),
                    ),
                  ),
                ),
              ),
              Center(
                child: Icon(
                  widget.icon,
                  size: widget.iconSize,
                  color: AppPalette.baseWhite,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

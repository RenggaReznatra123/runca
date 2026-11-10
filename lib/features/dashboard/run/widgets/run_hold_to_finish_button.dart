import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:runca/ui/color.dart';
import 'package:runca/ui/typography.dart';

/// Tombol oranye "Hold to Finish": harus ditahan sampai penuh baru
/// mengakhiri lari, supaya tidak tertekan tidak sengaja.
class RunHoldToFinishButton extends StatefulWidget {
  const RunHoldToFinishButton({super.key, required this.onFinish});

  final VoidCallback onFinish;

  @override
  State<RunHoldToFinishButton> createState() => _RunHoldToFinishButtonState();
}

class _RunHoldToFinishButtonState extends State<RunHoldToFinishButton>
    with SingleTickerProviderStateMixin {
  // ASUMSI: lama menahan 2 detik (belum ada di Figma).
  static const Duration _holdDuration = Duration(seconds: 2);

  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: _holdDuration,
  );

  @override
  void initState() {
    super.initState();
    _controller.addStatusListener(_onStatus);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onStatus(AnimationStatus status) {
    if (status != AnimationStatus.completed) return;

    HapticFeedback.mediumImpact();
    widget.onFinish();

    // Kembali ke awal supaya bisa ditahan lagi (misalnya setelah
    // memilih Continue Run di dialog).
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
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: AppPalette.runFinish.withValues(alpha: 0.35),
            width: 3,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Stack(
            fit: StackFit.expand,
            children: [
              const ColoredBox(color: AppPalette.runFinish),
              AnimatedBuilder(
                animation: _controller,
                builder: (context, _) => FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: _controller.value,
                  heightFactor: 1,
                  child: ColoredBox(
                    color: AppPalette.baseBlack.withValues(alpha: 0.18),
                  ),
                ),
              ),
              Center(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: AppPalette.baseWhite,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Hold to Finish',
                        style: AppTypography.titleSmall(
                          color: AppPalette.baseWhite,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

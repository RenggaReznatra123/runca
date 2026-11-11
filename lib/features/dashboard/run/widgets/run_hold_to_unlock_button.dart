import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:runca/ui/color.dart';
import 'package:runca/ui/typography.dart';

/// Tombol "Hold to Unlock" di layar terkunci: harus ditahan sampai penuh
/// baru kunci terbuka, supaya tidak terbuka tidak sengaja.
class RunHoldToUnlockButton extends StatefulWidget {
  const RunHoldToUnlockButton({super.key, required this.onUnlock});

  final VoidCallback onUnlock;

  @override
  State<RunHoldToUnlockButton> createState() => _RunHoldToUnlockButtonState();
}

class _RunHoldToUnlockButtonState extends State<RunHoldToUnlockButton>
    with SingleTickerProviderStateMixin {
  // ASUMSI: lama menahan 1 detik (belum ada di Figma).
  static const Duration _holdDuration = Duration(seconds: 1);

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
    widget.onUnlock();

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
          borderRadius: BorderRadius.circular(21),
          border: Border.all(
            color: AppPalette.profileMutedText.withValues(alpha: 0.5),
            width: 5,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            fit: StackFit.expand,
            children: [
              const ColoredBox(color: AppPalette.profileMutedText),
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
                      const Icon(
                        Icons.lock_outline_rounded,
                        size: 24,
                        color: AppPalette.baseWhite,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Hold to Unlock',
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

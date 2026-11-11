import 'package:flutter/material.dart';

import 'package:runca/ui/color.dart';
import 'package:runca/ui/typography.dart';

import 'run_hold_to_finish_button.dart';
import 'run_hold_to_unlock_button.dart';

/// Baris tombol bawah: Pause + gembok (berjalan), Resume + Hold to Finish
/// (dijeda), atau Hold to Unlock (terkunci).
class RunPanelButtons extends StatelessWidget {
  const RunPanelButtons({
    super.key,
    required this.isPaused,
    required this.isLocked,
    required this.onPause,
    required this.onResume,
    required this.onLock,
    required this.onUnlock,
    required this.onFinish,
  });

  static const double height = 68;

  final bool isPaused;
  final bool isLocked;
  final VoidCallback onPause;
  final VoidCallback onResume;
  final VoidCallback onLock;
  final VoidCallback onUnlock;
  final VoidCallback onFinish;

  @override
  Widget build(BuildContext context) {
    final Widget content;

    if (isLocked) {
      content = RunHoldToUnlockButton(onUnlock: onUnlock);
    } else if (isPaused) {
      content = _PausedButtons(onResume: onResume, onFinish: onFinish);
    } else {
      content = _RunningButtons(onPause: onPause, onLock: onLock);
    }

    return SizedBox(height: height, child: content);
  }
}

ButtonStyle _primaryStyle() {
  return ElevatedButton.styleFrom(
    backgroundColor: AppPalette.profileAccent,
    foregroundColor: AppPalette.baseWhite,
    elevation: 0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  );
}

class _RunningButtons extends StatelessWidget {
  const _RunningButtons({required this.onPause, required this.onLock});

  final VoidCallback onPause;
  final VoidCallback onLock;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: onPause,
            style: _primaryStyle(),
            icon: const Icon(Icons.pause_rounded, size: 26),
            label: Text(
              'Pause',
              style: AppTypography.titleMedium(color: AppPalette.baseWhite),
            ),
          ),
        ),
        const SizedBox(width: 18),
        SizedBox(
          width: 72,
          child: OutlinedButton(
            onPressed: onLock,
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.zero,
              side: const BorderSide(color: AppPalette.profileAccent),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Icon(
              Icons.lock_outline_rounded,
              size: 26,
              color: AppPalette.profileAccent,
            ),
          ),
        ),
      ],
    );
  }
}

class _PausedButtons extends StatelessWidget {
  const _PausedButtons({required this.onResume, required this.onFinish});

  final VoidCallback onResume;
  final VoidCallback onFinish;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: onResume,
            style: _primaryStyle(),
            icon: const Icon(Icons.play_arrow_rounded, size: 26),
            label: Text(
              'Resume',
              style: AppTypography.titleMedium(color: AppPalette.baseWhite),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(child: RunHoldToFinishButton(onFinish: onFinish)),
      ],
    );
  }
}

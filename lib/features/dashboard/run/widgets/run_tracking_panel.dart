import 'package:flutter/material.dart';

import 'package:runca/ui/color.dart';
import 'package:runca/ui/typography.dart';

import '../models/run_goal.dart';
import 'run_hold_to_finish_button.dart';
import 'run_metrics.dart';
import 'run_panel_shell.dart';

/// Panel bawah saat lari berjalan atau dijeda.
class RunTrackingPanel extends StatelessWidget {
  const RunTrackingPanel({
    super.key,
    required this.distanceKm,
    required this.durationSeconds,
    required this.paceSecondsPerKm,
    required this.calories,
    required this.goal,
    required this.isPaused,
    required this.onPause,
    required this.onResume,
    required this.onLock,
    required this.onFinish,
  });

  final double distanceKm;
  final int durationSeconds;
  final int? paceSecondsPerKm;
  final int calories;
  final RunGoal? goal;
  final bool isPaused;
  final VoidCallback onPause;
  final VoidCallback onResume;
  final VoidCallback onLock;
  final VoidCallback onFinish;

  @override
  Widget build(BuildContext context) {
    return RunPanelShell(
      child: Column(
        children: [
          RunMetrics(
            distanceKm: distanceKm,
            durationSeconds: durationSeconds,
            paceSecondsPerKm: paceSecondsPerKm,
            calories: calories,
            goal: goal,
            highlighted: isPaused,
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
              height: 68,
              child: isPaused
                  ? _PausedButtons(onResume: onResume, onFinish: onFinish)
                  : _RunningButtons(onPause: onPause, onLock: onLock),
            ),
          ),
        ],
      ),
    );
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
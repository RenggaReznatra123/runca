import 'package:flutter/material.dart';

import 'package:runca/ui/color.dart';
import 'package:runca/ui/typography.dart';

import '../models/run_goal.dart';
import 'run_metrics.dart';
import 'run_panel_shell.dart';

/// Panel bawah layar Setup: angka awal, tombol target, dan Start Run.
class RunStatsPanel extends StatelessWidget {
  const RunStatsPanel({
    super.key,
    required this.distanceKm,
    required this.durationSeconds,
    required this.paceSecondsPerKm,
    required this.calories,
    required this.goal,
    required this.onGoalTap,
    required this.onStartRun,
  });

  /// Tinggi panel tanpa area gesture sistem di bawah.
  static const double contentHeight = RunPanelShell.contentHeight;

  final double distanceKm;
  final int durationSeconds;
  final int? paceSecondsPerKm;
  final int calories;

  /// Target lari. Null berarti tanpa target.
  final RunGoal? goal;
  final VoidCallback onGoalTap;
  final VoidCallback onStartRun;

  @override
  Widget build(BuildContext context) {
    final hasGoal = goal != null;

    return RunPanelShell(
      child: Column(
        children: [
          RunMetrics(
            distanceKm: distanceKm,
            durationSeconds: durationSeconds,
            paceSecondsPerKm: paceSecondsPerKm,
            calories: calories,
            goal: goal,
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
              height: 68,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    width: 135,
                    child: OutlinedButton.icon(
                      onPressed: onGoalTap,
                      icon: const Icon(
                        Icons.track_changes_rounded,
                        size: 22,
                        color: AppPalette.profileAccent,
                      ),
                      label: Text(
                        hasGoal ? 'Edit Goal' : 'Set Goal',
                        style: AppTypography.titleSmall(
                          color: AppPalette.textNeutralPrimary,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        side: BorderSide(
                          color: hasGoal
                              ? AppPalette.profileAccent
                              : AppPalette.borderButtonOutlinedDefault,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      // Start Run baru aktif setelah target diatur.
                      onPressed: hasGoal ? onStartRun : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppPalette.profileAccent,
                        foregroundColor: AppPalette.baseWhite,
                        disabledBackgroundColor: AppPalette.profileDisabledFill,
                        disabledForegroundColor: AppPalette.profileMutedIcon,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        'Start Run',
                        style: AppTypography.titleMedium(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

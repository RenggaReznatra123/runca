import 'package:flutter/material.dart';

import 'package:runca/ui/color.dart';
import 'package:runca/ui/typography.dart';
import 'package:runca/utility/format_utils.dart';

import '../models/run_goal.dart';

/// Panel bawah: angka utama, tiga statistik, tombol target, dan Start Run.
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
  static const double contentHeight = 267;

  final double distanceKm;
  final int durationSeconds;
  final int? paceSecondsPerKm;
  final int calories;

  /// Target lari. Null berarti tanpa target.
  final RunGoal? goal;
  final VoidCallback onGoalTap;
  final VoidCallback onStartRun;

  /// Angka utama: jarak (tanpa target), atau pencapaian berbanding target.
  Widget _headline() {
    return switch (goal) {
      TimeGoal(:final seconds) => _Headline(
        current: AppFormat.countdownMinutesSeconds(durationSeconds),
        target: AppFormat.countdownMinutesSeconds(seconds),
        label: 'Duration',
      ),
      DistanceGoal(:final km) => _Headline(
        current: AppFormat.distanceNumber(distanceKm),
        target: AppFormat.distanceValue(km),
        label: 'Distance (km)',
      ),
      null => _Headline(
        current: AppFormat.distanceNumber(distanceKm),
        label: 'Distance (km)',
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final hasGoal = goal != null;

    // Angka yang sudah jadi angka utama tidak diulang di baris statistik.
    final isTimeGoal = goal is TimeGoal;

    return Container(
      height: contentHeight + bottomInset,
      decoration: BoxDecoration(
        color: AppPalette.baseWhite,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: AppPalette.baseBlack.withValues(alpha: 0.12),
            blurRadius: 24,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(
            width: 126,
            height: 4,
            decoration: BoxDecoration(
              color: AppPalette.profileSoftBorder,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 13),
          _headline(),
          const SizedBox(height: 24),
          SizedBox(
            height: 47,
            child: Row(
              children: [
                Expanded(
                  child: _Stat(
                    value: AppFormat.paceOrPlaceholder(paceSecondsPerKm),
                    label: 'Pace (/km)',
                  ),
                ),
                const _StatDivider(),
                Expanded(
                  child: isTimeGoal
                      ? _Stat(
                          value: AppFormat.distanceNumber(distanceKm),
                          label: 'Distance (km)',
                        )
                      : _Stat(
                          value: AppFormat.clockDuration(durationSeconds),
                          label: 'Duration',
                        ),
                ),
                const _StatDivider(),
                Expanded(
                  child: _Stat(
                    value: AppFormat.integer(calories),
                    label: 'Calories (kcal)',
                  ),
                ),
              ],
            ),
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

/// Angka utama dan labelnya. Kalau ada [target], tampil "current / target"
/// dengan target berwarna tosca.
class _Headline extends StatelessWidget {
  const _Headline({required this.current, required this.label, this.target});

  final String current;
  final String? target;
  final String label;

  @override
  Widget build(BuildContext context) {
    final style = AppTypography.headlineSmall(
      color: AppPalette.textNeutralPrimary,
    ).copyWith(fontSize: 36, fontWeight: AppTypography.semiBold);
    final targetText = target;

    return Column(
      children: [
        SizedBox(
          height: 44,
          child: Center(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text.rich(
                TextSpan(
                  style: style,
                  children: [
                    TextSpan(text: current),
                    if (targetText != null) ...[
                      const TextSpan(text: ' / '),
                      TextSpan(
                        text: targetText,
                        style: style.copyWith(color: AppPalette.profileAccent),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 3),
        SizedBox(
          height: 16,
          child: Center(
            child: Text(
              label,
              style: AppTypography.bodySmall(
                color: AppPalette.profileMutedText,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 24,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              maxLines: 1,
              style: AppTypography.titleMedium(
                color: AppPalette.textNeutralPrimary,
              ).copyWith(fontSize: 20, fontWeight: AppTypography.semiBold),
            ),
          ),
        ),
        const SizedBox(height: 7),
        SizedBox(
          height: 16,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              maxLines: 1,
              style: AppTypography.bodySmall(
                color: AppPalette.profileMutedText,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _StatDivider extends StatelessWidget {
  const _StatDivider();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 1,
      height: 36,
      child: ColoredBox(color: AppPalette.borderNeutral),
    );
  }
}

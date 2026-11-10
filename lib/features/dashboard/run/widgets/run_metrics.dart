import 'package:flutter/material.dart';

import 'package:runca/ui/color.dart';
import 'package:runca/ui/typography.dart';
import 'package:runca/utility/format_utils.dart';

import '../models/run_goal.dart';

/// Angka utama (jarak, atau pencapaian berbanding target) dan tiga statistik.
/// Kalau [highlighted], angka utama berlatar kuning (tampilan jeda).
class RunMetrics extends StatelessWidget {
  const RunMetrics({
    super.key,
    required this.distanceKm,
    required this.durationSeconds,
    required this.paceSecondsPerKm,
    required this.calories,
    required this.goal,
    this.highlighted = false,
  });

  final double distanceKm;
  final int durationSeconds;
  final int? paceSecondsPerKm;
  final int calories;

  /// Target lari. Null berarti tanpa target.
  final RunGoal? goal;
  final bool highlighted;

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
    // Angka yang sudah jadi angka utama tidak diulang di baris statistik.
    final isTimeGoal = goal is TimeGoal;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            height: 73,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: highlighted
                  ? AppPalette.bgHoverWarning
                  : AppPalette.transparent,
              borderRadius: BorderRadius.circular(16),
            ),
            child: _headline(),
          ),
        ),
        const SizedBox(height: 19),
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
      ],
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
      mainAxisSize: MainAxisSize.min,
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

import 'package:flutter/material.dart';

import 'package:runca/features/dashboard/activity/models/activity_model.dart';
import 'package:runca/ui/color.dart';
import 'package:runca/utility/format_utils.dart';

import 'treadmill_metric.dart';
import 'treadmill_round_button.dart';
import 'treadmill_side_lines.dart';
import 'treadmill_top_bar.dart';

/// Isi layar Setup saat jenis aktivitas Treadmill: tanpa peta, hanya waktu,
/// langkah, dan tombol play.
class TreadmillSetupView extends StatelessWidget {
  const TreadmillSetupView({
    super.key,
    required this.activityType,
    required this.onBack,
    required this.onTypeTap,
    required this.onSettingsTap,
    required this.onStart,
    this.durationSeconds = 0,
    this.steps = 0,
  });

  // Posisi dari Figma (frame tinggi 917), sebagai pecahan tinggi layar.
  static const double _timeCenter = 320 / 917;
  static const double _stepsCenter = 535 / 917;
  static const double _linesTop = 392 / 917;

  final ActivityType activityType;
  final VoidCallback onBack;
  final VoidCallback onTypeTap;
  final VoidCallback onSettingsTap;
  final VoidCallback onStart;
  final int durationSeconds;
  final int steps;

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.paddingOf(context).top;
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return ColoredBox(
      color: AppPalette.baseWhite,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final height = constraints.maxHeight;
          const half = TreadmillMetric.valueHeight / 2;

          return Stack(
            children: [
              Positioned(
                top: height * _linesTop,
                left: 0,
                right: 0,
                child: const TreadmillSideLines(),
              ),
              Positioned(
                top: topInset + 38,
                left: 20,
                right: 20,
                child: TreadmillTopBar(
                  activityType: activityType,
                  onBack: onBack,
                  onTypeTap: onTypeTap,
                  onSettingsTap: onSettingsTap,
                ),
              ),
              Positioned(
                top: height * _timeCenter - half,
                left: 0,
                right: 0,
                child: Center(
                  child: TreadmillMetric(
                    value: AppFormat.countdownMinutesSeconds(durationSeconds),
                    label: 'Time',
                  ),
                ),
              ),
              Positioned(
                top: height * _stepsCenter - half,
                left: 0,
                right: 0,
                child: Center(
                  child: TreadmillMetric(
                    value: AppFormat.integer(steps),
                    label: 'Steps',
                  ),
                ),
              ),
              Positioned(
                bottom: bottomInset + 64,
                left: 0,
                right: 0,
                child: Center(
                  child: TreadmillRoundButton(
                    icon: Icons.play_arrow_rounded,
                    onPressed: onStart,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

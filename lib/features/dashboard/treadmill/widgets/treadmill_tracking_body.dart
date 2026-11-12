import 'package:flutter/material.dart';

import 'package:runca/features/dashboard/run/widgets/treadmill_metric.dart';
import 'package:runca/features/dashboard/run/widgets/treadmill_round_button.dart';
import 'package:runca/features/dashboard/run/widgets/treadmill_side_lines.dart';
import 'package:runca/ui/color.dart';
import 'package:runca/ui/typography.dart';
import 'package:runca/utility/format_utils.dart';

import 'treadmill_hold_button.dart';
import 'treadmill_lock_button.dart';

/// Isi layar Tracking Treadmill di bawah bar atas: judul PAUSED, Time, Steps,
/// garis miring, dan tombol sesuai kondisi (berjalan, dijeda, terkunci).
class TreadmillTrackingBody extends StatelessWidget {
  const TreadmillTrackingBody({
    super.key,
    required this.durationSeconds,
    required this.steps,
    required this.isPaused,
    required this.isLocked,
    required this.onPause,
    required this.onResume,
    required this.onLock,
    required this.onUnlock,
    required this.onFinish,
  });

  // Posisi dari Figma (frame 412 x 917), sebagai pecahan layar.
  static const double _linesTop = 412 / 917;
  static const double _timeCenter = 333 / 917;
  static const double _stepsCenter = 544 / 917;
  static const double _pausedShift = 49 / 917;
  static const double _pausedTitleCenter = 235 / 917;
  static const double _runningButtonsY = 776 / 917;
  static const double _pausedButtonsY = 792 / 917;

  // ASUMSI: lama menahan (belum ada di Figma).
  static const Duration _finishHold = Duration(seconds: 2);
  static const Duration _unlockHold = Duration(seconds: 1);

  final int durationSeconds;
  final int steps;
  final bool isPaused;
  final bool isLocked;
  final VoidCallback onPause;
  final VoidCallback onResume;
  final VoidCallback onLock;
  final VoidCallback onUnlock;
  final VoidCallback onFinish;

  Widget _at({
    required double x,
    required double y,
    required double size,
    required Widget child,
  }) {
    return Positioned(
      left: x - size / 2,
      top: y - size / 2,
      width: size,
      height: size,
      child: child,
    );
  }

  List<Widget> _buttons(double width, double height) {
    if (isLocked) {
      return [
        _at(
          x: width / 2,
          y: height * _runningButtonsY,
          size: 96,
          child: TreadmillHoldButton(
            icon: Icons.lock_outline_rounded,
            iconSize: 26,
            color: AppPalette.profileMutedText,
            ringWidth: 8,
            holdDuration: _unlockHold,
            onCompleted: onUnlock,
          ),
        ),
      ];
    }

    if (isPaused) {
      final y = height * _pausedButtonsY;

      return [
        _at(
          x: width * 133 / 412,
          y: y,
          size: 80,
          child: TreadmillRoundButton(
            icon: Icons.play_arrow_rounded,
            size: 80,
            onPressed: onResume,
          ),
        ),
        _at(
          x: width * 284 / 412,
          y: y,
          size: 88,
          child: TreadmillHoldButton(
            icon: Icons.stop_rounded,
            iconSize: 34,
            color: AppPalette.runFinish,
            ringWidth: 8,
            holdDuration: _finishHold,
            onCompleted: onFinish,
          ),
        ),
      ];
    }

    final y = height * _runningButtonsY;

    return [
      _at(
        x: width / 2,
        y: y,
        size: 80,
        child: TreadmillRoundButton(
          icon: Icons.pause_rounded,
          size: 80,
          onPressed: onPause,
        ),
      ),
      _at(
        x: width * 332 / 412,
        y: y,
        size: 70,
        child: TreadmillLockButton(onPressed: onLock),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    const half = TreadmillMetric.valueHeight / 2;

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;
        final shift = isPaused ? _pausedShift : 0.0;

        return Stack(
          children: [
            Positioned(
              top: height * _linesTop,
              left: 0,
              right: 0,
              child: const TreadmillSideLines(),
            ),
            if (isPaused)
              Positioned(
                top: height * _pausedTitleCenter - 30,
                left: 0,
                right: 0,
                height: 60,
                child: Center(
                  child: Text(
                    'PAUSED',
                    style: AppTypography.headlineSmall(
                      color: AppPalette.profileAccent,
                    ).copyWith(fontSize: 44, fontWeight: AppTypography.bold),
                  ),
                ),
              ),
            Positioned(
              top: height * (_timeCenter + shift) - half,
              left: 0,
              right: 0,
              child: Center(
                child: TreadmillMetric(
                  value: AppFormat.duration(durationSeconds),
                  label: 'TIME',
                  labelColor: AppPalette.profileMutedText,
                ),
              ),
            ),
            Positioned(
              top: height * (_stepsCenter + shift) - half,
              left: 0,
              right: 0,
              child: Center(
                child: TreadmillMetric(
                  value: AppFormat.thousands(steps),
                  label: 'Steps',
                ),
              ),
            ),
            ..._buttons(width, height),
          ],
        );
      },
    );
  }
}

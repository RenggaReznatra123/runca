import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:runca/features/dashboard/activity/models/activity_model.dart';
import 'package:runca/ui/color.dart';
import 'package:runca/ui/typography.dart';

import 'cubit/run_countdown_cubit.dart';
import 'cubit/run_countdown_state.dart';
import 'models/location_fix.dart';
import 'widgets/activity_type_presentation.dart';
import 'widgets/run_countdown_circle.dart';
import 'widgets/run_countdown_map.dart';
import 'widgets/run_map_attribution.dart';

/// Layar hitung mundur sebelum lari dimulai. Kalau hitung mundur
/// selesai, [onFinished] dipanggil (pemanggil yang menentukan layar
/// berikutnya). Kalau dibatalkan (back), [onFinished] tidak dipanggil.
class RunCountdownScreen extends StatelessWidget {
  const RunCountdownScreen({
    super.key,
    required this.activityType,
    required this.position,
    required this.onFinished,
    this.seconds = RunCountdownCubit.defaultSeconds,
  });

  final ActivityType activityType;

  /// Lokasi terakhir, untuk pusat peta latar. Null memakai pusat bawaan.
  final LocationFix? position;
  final VoidCallback onFinished;

  /// Lama hitung mundur dari Run Settings.
  final int seconds;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RunCountdownCubit(seconds: seconds),
      child: _RunCountdownView(
        activityType: activityType,
        position: position,
        onFinished: onFinished,
      ),
    );
  }
}

class _RunCountdownView extends StatelessWidget {
  const _RunCountdownView({
    required this.activityType,
    required this.position,
    required this.onFinished,
  });

  // Posisi relatif dari Figma (frame tinggi 917): pusat lingkaran di y 383,
  // titik lokasi 57 di bawah pusat lingkaran.
  static const double _circleCenterFraction = 383 / 917;
  // Treadmill: tanpa peta, lingkaran di y 411.
  static const double _treadmillCircleCenterFraction = 411 / 917;
  static const double _dotBelowCenter = 57;
  static const double _mapHeight = 560;
  static const double _titleGap = 46;

  final ActivityType activityType;
  final LocationFix? position;
  final VoidCallback onFinished;

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.paddingOf(context).top;
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final isTreadmill = activityType == ActivityType.treadmill;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: AppPalette.transparent,
      ),
      child: BlocListener<RunCountdownCubit, RunCountdownState>(
        listenWhen: (previous, current) =>
            !previous.finished && current.finished,
        listener: (context, state) => onFinished(),
        child: Scaffold(
          backgroundColor: AppPalette.baseWhite,
          body: LayoutBuilder(
            builder: (context, constraints) {
              final circleCenterY =
                  constraints.maxHeight *
                  (isTreadmill
                      ? _treadmillCircleCenterFraction
                      : _circleCenterFraction);
              final circleTop = circleCenterY - RunCountdownCircle.size / 2;
              final mapCenterY = circleCenterY + _dotBelowCenter;

              return Stack(
                children: [
                  if (!isTreadmill) ...[
                    Positioned(
                      top: mapCenterY - _mapHeight / 2,
                      left: 0,
                      right: 0,
                      height: _mapHeight,
                      child: RunCountdownMap(position: position),
                    ),
                    Positioned(
                      top: topInset + 36,
                      left: 0,
                      right: 0,
                      child: _ActivityLabel(type: activityType),
                    ),
                  ],
                  Positioned(
                    top: circleTop,
                    left: 0,
                    right: 0,
                    child: Center(
                      child:
                          BlocSelector<
                            RunCountdownCubit,
                            RunCountdownState,
                            int
                          >(
                            selector: (state) => state.remaining,
                            builder: (context, remaining) =>
                                RunCountdownCircle(number: remaining),
                          ),
                    ),
                  ),
                  Positioned(
                    top: circleTop + RunCountdownCircle.size + _titleGap,
                    left: 20,
                    right: 20,
                    child: const _GetReadyText(),
                  ),
                  if (!isTreadmill)
                    Positioned(
                      right: 10,
                      bottom: bottomInset + 8,
                      child: const RunMapAttribution(),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _ActivityLabel extends StatelessWidget {
  const _ActivityLabel({required this.type});

  final ActivityType type;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(type.icon, size: 20, color: AppPalette.profileAccent),
        const SizedBox(width: 6),
        Text(
          type.label,
          style: AppTypography.titleSmall(color: AppPalette.profileAccent),
        ),
      ],
    );
  }
}

class _GetReadyText extends StatelessWidget {
  const _GetReadyText();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Get Ready!',
          textAlign: TextAlign.center,
          style: AppTypography.headlineSmall(color: AppPalette.profileDarkText),
        ),
        const SizedBox(height: 4),
        Text(
          'Lari kamu akan segera dimulai',
          textAlign: TextAlign.center,
          style: AppTypography.bodyMedium(color: AppPalette.profileMutedText),
        ),
      ],
    );
  }
}

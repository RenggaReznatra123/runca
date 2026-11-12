import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:runca/features/dashboard/activity/models/activity_model.dart';
import 'package:runca/features/dashboard/run/models/run_settings.dart';
import 'package:runca/features/dashboard/run/run_settings_screen.dart';
import 'package:runca/features/dashboard/run/run_summary_screen.dart';
import 'package:runca/features/dashboard/run/widgets/run_no_activity_dialog.dart';
import 'package:runca/features/dashboard/run/widgets/run_top_bar.dart';
import 'package:runca/ui/color.dart';
import 'package:runca/ui/shared_view/keep_screen_awake.dart';
import 'package:runca/utility/format_utils.dart';
import 'package:runca/utility/snackbar_extension.dart';

import 'cubit/treadmill_tracking_cubit.dart';
import 'cubit/treadmill_tracking_state.dart';
import 'widgets/treadmill_tracking_body.dart';

/// Layar Tracking Treadmill: waktu, langkah, dan tombol Pause, Lock, Resume,
/// serta Stop (ditahan).
class TreadmillTrackingScreen extends StatelessWidget {
  const TreadmillTrackingScreen({super.key, required this.settings});

  /// Pengaturan lari saat dimulai (dipakai untuk Keep Screen Awake).
  final RunSettings settings;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TreadmillTrackingCubit(),
      child: KeepScreenAwake(
        enabled: settings.keepScreenAwake,
        child: const _TreadmillTrackingView(),
      ),
    );
  }
}

class _TreadmillTrackingView extends StatelessWidget {
  const _TreadmillTrackingView();

  void _openSettings(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const RunSettingsScreen()));
  }

  void _showUnavailable(BuildContext context, String page) {
    context.showUnavailableSnackbar(page, duration: const Duration(seconds: 2));
  }

  // ASUMSI: teks petunjuk (belum ada di Figma).
  void _showLockedHint(BuildContext context) {
    context.showInfoSnackbar(
      'Hold the button below to unlock.',
      duration: const Duration(seconds: 2),
    );
  }

  /// Stop selesai ditahan: kalau belum ada data, tampilkan dialog dan tetap
  /// dijeda. Kalau ada data, akhiri (lanjut ke layar ringkasan).
  Future<void> _handleFinish(BuildContext context) async {
    final cubit = context.read<TreadmillTrackingCubit>();

    if (!cubit.hasRecordedData) {
      final discard = await RunNoActivityDialog.show(context);

      if (discard == true && context.mounted) Navigator.of(context).pop();
      return;
    }

    cubit.finish();
  }

  void _openSummary(BuildContext context) {
    final cubit = context.read<TreadmillTrackingCubit>();
    final draft = cubit.buildDraft(
      title: AppFormat.defaultActivityTitle(
        cubit.startedAt,
        noun: ActivityType.treadmill.label,
      ),
    );

    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (_) => RunSummaryScreen(draft: draft)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.paddingOf(context).top;
    final cubit = context.read<TreadmillTrackingCubit>();

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;

        context.showInfoSnackbar(
          'Pause, then hold Stop to end it.',
          duration: const Duration(seconds: 2),
        );
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark.copyWith(
          statusBarColor: AppPalette.transparent,
        ),
        child: BlocListener<TreadmillTrackingCubit, TreadmillTrackingState>(
          listenWhen: (previous, current) =>
              previous.status != TreadmillTrackingStatus.finished &&
              current.status == TreadmillTrackingStatus.finished,
          listener: (context, state) => _openSummary(context),
          child: Scaffold(
            backgroundColor: AppPalette.baseWhite,
            body: BlocBuilder<TreadmillTrackingCubit, TreadmillTrackingState>(
              builder: (context, state) {
                final locked = state.isLocked;

                return Stack(
                  children: [
                    Positioned.fill(
                      child: TreadmillTrackingBody(
                        durationSeconds: state.durationSeconds,
                        steps: state.steps,
                        isPaused:
                            state.status == TreadmillTrackingStatus.paused,
                        isLocked: locked,
                        onPause: cubit.pause,
                        onResume: cubit.resume,
                        onLock: cubit.lock,
                        onUnlock: cubit.unlock,
                        onFinish: () => _handleFinish(context),
                      ),
                    ),
                    Positioned(
                      top: topInset + 40,
                      left: 20,
                      right: 20,
                      child: RunTopBar(
                        activityType: ActivityType.treadmill,
                        leadingIcon: Icons.keyboard_arrow_down_rounded,
                        onBack: () => locked
                            ? _showLockedHint(context)
                            : _showUnavailable(context, 'Minimize'),
                        onSettingsTap: () => locked
                            ? _showLockedHint(context)
                            : _openSettings(context),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import 'package:runca/config/map_config.dart';
import 'package:runca/features/dashboard/activity/models/activity_model.dart';
import 'package:runca/ui/color.dart';
import 'package:runca/ui/shared_view/keep_screen_awake.dart';
import 'package:runca/utility/format_utils.dart';
import 'package:runca/utility/snackbar_extension.dart';

import 'cubit/run_tracking_cubit.dart';
import 'cubit/run_tracking_state.dart';
import 'models/location_fix.dart';
import 'models/run_goal.dart';
import 'models/run_settings.dart';
import 'run_settings_screen.dart';
import 'run_summary_screen.dart';
import 'widgets/run_floating_controls.dart';
import 'widgets/run_map_attribution.dart';
import 'widgets/run_map_view.dart';
import 'widgets/run_no_activity_dialog.dart';
import 'widgets/run_panel_shell.dart';
import 'widgets/run_top_bar.dart';
import 'widgets/run_tracking_panel.dart';

/// Layar Tracking: peta dengan rute, statistik langsung, dan tombol
/// Pause, Resume, Lock, serta Hold to Finish.
class RunTrackingScreen extends StatelessWidget {
  const RunTrackingScreen({
    super.key,
    required this.activityType,
    required this.goal,
    required this.initialPosition,
    required this.settings,
  });

  final ActivityType activityType;
  final RunGoal? goal;

  /// Lokasi terakhir dari layar Setup. Null kalau belum ada sinyal GPS.
  final LocationFix? initialPosition;

  /// Pengaturan lari saat dimulai (Auto Pause, Auto Lap, Keep Screen Awake).
  final RunSettings settings;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RunTrackingCubit(
        activityType: activityType,
        initialPosition: initialPosition,
        autoPause: settings.autoPause,
        lapKm: settings.autoLap.km,
      ),
      child: KeepScreenAwake(
        enabled: settings.keepScreenAwake,
        child: _RunTrackingView(activityType: activityType, goal: goal),
      ),
    );
  }
}

class _RunTrackingView extends StatefulWidget {
  const _RunTrackingView({required this.activityType, required this.goal});

  final ActivityType activityType;
  final RunGoal? goal;

  @override
  State<_RunTrackingView> createState() => _RunTrackingViewState();
}

class _RunTrackingViewState extends State<_RunTrackingView> {
  final MapController _mapController = MapController();
  bool _mapReady = false;

  // Peta mengikuti posisi sampai pengguna menggesernya sendiri.
  bool _follow = true;

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  void _moveTo(LocationFix fix, {double? zoom}) {
    if (!_mapReady) return;

    _mapController.move(
      LatLng(fix.latitude, fix.longitude),
      zoom ?? _mapController.camera.zoom,
    );
  }

  void _handleMapReady() {
    _mapReady = true;

    final fix = context.read<RunTrackingCubit>().state.position;
    if (fix != null) _moveTo(fix, zoom: MapConfig.followZoom);
  }

  void _onLocateTap() {
    final fix = context.read<RunTrackingCubit>().state.position;

    if (fix == null) {
      context.showInfoSnackbar(
        'Waiting for GPS signal...',
        duration: const Duration(seconds: 2),
      );
      return;
    }

    _follow = true;
    _moveTo(fix, zoom: MapConfig.followZoom);
  }

  void _openSettings() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const RunSettingsScreen()));
  }

  void _showUnavailable(String page) {
    context.showUnavailableSnackbar(page, duration: const Duration(seconds: 2));
  }

  // ASUMSI: teks petunjuk (belum ada desain layar terkunci di Figma).
  void _showLockedHint() {
    context.showInfoSnackbar(
      'Hold the button below to unlock.',
      duration: const Duration(seconds: 2),
    );
  }

  /// Finish ditekan: kalau belum ada data, tampilkan dialog dan lari tetap
  /// dijeda. Kalau ada data, akhiri lari (lanjut ke layar ringkasan).
  Future<void> _handleFinish() async {
    final cubit = context.read<RunTrackingCubit>();

    if (!cubit.hasRecordedData) {
      final discard = await RunNoActivityDialog.show(context);

      if (discard == true && mounted) Navigator.of(context).pop();
      return;
    }

    cubit.finish();
  }

  void _openSummary() {
    final trackingCubit = context.read<RunTrackingCubit>();
    final noun = widget.activityType == ActivityType.cycling ? 'Ride' : 'Run';
    final draft = trackingCubit.buildDraft(
      title: AppFormat.defaultActivityTitle(
        trackingCubit.startedAt,
        noun: noun,
      ),
    );

    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (_) => RunSummaryScreen(draft: draft)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.paddingOf(context).top;
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final panelHeight = RunPanelShell.contentHeight + bottomInset;
    final cubit = context.read<RunTrackingCubit>();

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;

        context.showInfoSnackbar(
          'Pause your run, then hold Finish to end it.',
          duration: const Duration(seconds: 2),
        );
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark.copyWith(
          statusBarColor: AppPalette.transparent,
        ),
        child: MultiBlocListener(
          listeners: [
            BlocListener<RunTrackingCubit, RunTrackingState>(
              listenWhen: (previous, current) =>
                  previous.position != current.position,
              listener: (context, state) {
                final fix = state.position;
                if (_follow && fix != null) _moveTo(fix);
              },
            ),
            BlocListener<RunTrackingCubit, RunTrackingState>(
              listenWhen: (previous, current) =>
                  previous.status != RunTrackingStatus.finished &&
                  current.status == RunTrackingStatus.finished,
              listener: (context, state) => _openSummary(),
            ),
          ],
          child: Scaffold(
            backgroundColor: AppPalette.bgSurfaceNeutral,
            body: Stack(
              children: [
                // Peta berhenti 24 di bawah puncak panel, supaya sudut
                // melengkung panel tetap berlatar peta.
                Positioned.fill(
                  bottom: panelHeight - 24,
                  child: BlocBuilder<RunTrackingCubit, RunTrackingState>(
                    buildWhen: (previous, current) =>
                        previous.position != current.position ||
                        previous.route != current.route,
                    builder: (context, state) => RunMapView(
                      controller: _mapController,
                      position: state.position,
                      route: state.route,
                      onMapReady: _handleMapReady,
                      onGesture: () => _follow = false,
                    ),
                  ),
                ),
                Positioned(
                  top: topInset + 20,
                  left: 20,
                  right: 20,
                  child: RunTopBar(
                    activityType: widget.activityType,
                    leadingIcon: Icons.keyboard_arrow_down_rounded,
                    onBack: () => _showUnavailable('Minimize'),
                    onSettingsTap: _openSettings,
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: panelHeight,
                  height: RunFloatingControls.height,
                  child: BlocBuilder<RunTrackingCubit, RunTrackingState>(
                    buildWhen: (previous, current) =>
                        previous.position != current.position,
                    builder: (context, state) => RunFloatingControls(
                      accuracyMeters: state.position?.accuracyMeters,
                      onLayersTap: () => _showUnavailable('Map layers'),
                      onLocateTap: _onLocateTap,
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: panelHeight + 4,
                  child: const Center(child: RunMapAttribution()),
                ),
                // Saat terkunci, semua sentuhan di atas panel ditahan.
                Positioned.fill(
                  bottom: panelHeight,
                  child: BlocBuilder<RunTrackingCubit, RunTrackingState>(
                    buildWhen: (previous, current) =>
                        previous.isLocked != current.isLocked,
                    builder: (context, state) => state.isLocked
                        ? GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: _showLockedHint,
                          )
                        : const SizedBox.shrink(),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: BlocBuilder<RunTrackingCubit, RunTrackingState>(
                    builder: (context, state) => RunTrackingPanel(
                      distanceKm: state.distanceKm,
                      durationSeconds: state.durationSeconds,
                      paceSecondsPerKm: state.paceSecondsPerKm,
                      calories: state.calories,
                      goal: widget.goal,
                      splits: state.splits,
                      autoLapEnabled: state.autoLapEnabled,
                      isPaused: state.status == RunTrackingStatus.paused,
                      isLocked: state.isLocked,
                      onPause: cubit.pause,
                      onResume: cubit.resume,
                      onLock: cubit.lock,
                      onUnlock: cubit.unlock,
                      onFinish: _handleFinish,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

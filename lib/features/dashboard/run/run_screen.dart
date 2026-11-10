import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import 'package:runca/config/map_config.dart';
import 'package:runca/ui/color.dart';
import 'package:runca/utility/snackbar_extension.dart';

import 'cubit/run_cubit.dart';
import 'cubit/run_state.dart';
import 'models/location_fix.dart';
import 'run_countdown_screen.dart';
import 'run_location_messages.dart';
import 'run_tracking_screen.dart';
import 'widgets/run_activity_type_sheet.dart';
import 'widgets/run_challenge_button.dart';
import 'widgets/run_floating_controls.dart';
import 'widgets/run_goal_sheet.dart';
import 'widgets/run_map_attribution.dart';
import 'widgets/run_map_view.dart';
import 'widgets/run_stats_panel.dart';
import 'widgets/run_top_bar.dart';

/// Layar Setup lari: peta nyata, status GPS, target, dan tombol Start Run.
class RunScreen extends StatelessWidget {
  const RunScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (_) => RunCubit(), child: const _RunView());
  }
}

class _RunView extends StatefulWidget {
  const _RunView();

  @override
  State<_RunView> createState() => _RunViewState();
}

class _RunViewState extends State<_RunView> {
  final MapController _mapController = MapController();
  bool _mapReady = false;

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

    final fix = context.read<RunCubit>().state.position;
    if (fix != null) _moveTo(fix, zoom: MapConfig.followZoom);
  }

  Future<void> _selectType(RunState state) async {
    final cubit = context.read<RunCubit>();

    final result = await RunActivityTypeSheet.show(
      context,
      selected: state.activityType,
      onUnavailable: _showUnavailable,
    );

    if (result == null || cubit.isClosed) return;

    cubit.selectActivityType(result);
  }

  Future<void> _openGoalSheet(RunState state) async {
    final cubit = context.read<RunCubit>();

    final submission = await RunGoalSheet.show(
      context,
      current: state.goal,
      savedDistanceKm: state.savedDistanceKm,
      savedTimeSeconds: state.savedTimeSeconds,
    );

    if (submission == null || cubit.isClosed) return;

    cubit.saveGoal(submission);
  }

  void _startRun(RunState state) {
    // Lari hanya bisa dimulai kalau izin dan layanan lokasi sudah siap.
    if (state.locationStatus == RunLocationStatus.checking) {
      context.showInfoSnackbar(
        'Checking your location...',
        duration: const Duration(seconds: 2),
      );
      return;
    }

    if (state.locationStatus != RunLocationStatus.ready) {
      context.showRunLocationMessage(state.locationStatus);
      return;
    }

    final cubit = context.read<RunCubit>();
    final navigator = Navigator.of(context);
    final setupRoute = ModalRoute.of(context);

    navigator.push(
      MaterialPageRoute<void>(
        builder: (_) => RunCountdownScreen(
          activityType: state.activityType,
          position: state.position,
          onFinished: () {
            final latest = cubit.state;

            // Ganti countdown dengan Tracking, lalu buang layar Setup di
            // bawahnya supaya tidak ada kilatan layar Setup.
            navigator.pushReplacement(
              MaterialPageRoute<void>(
                builder: (_) => RunTrackingScreen(
                  activityType: latest.activityType,
                  goal: latest.goal,
                  initialPosition: latest.position,
                ),
              ),
            );
            if (setupRoute != null) navigator.removeRoute(setupRoute);
          },
        ),
      ),
    );
  }

  void _onLocateTap(RunState state) {
    final fix = state.position;

    if (state.locationStatus != RunLocationStatus.ready) {
      context.read<RunCubit>().startLocation();
      return;
    }

    if (fix == null) {
      context.showInfoSnackbar(
        'Waiting for GPS signal...',
        duration: const Duration(seconds: 2),
      );
      return;
    }

    _moveTo(fix, zoom: MapConfig.followZoom);
  }

  void _showUnavailable(String page) {
    context.showUnavailableSnackbar(page, duration: const Duration(seconds: 2));
  }

  /// Peta belum digambar selama izin dicek atau sinyal GPS belum datang,
  /// supaya tidak sempat tampil di lokasi bawaan lalu melompat.
  bool _waitingForPosition(RunState state) {
    return state.position == null &&
        (state.locationStatus == RunLocationStatus.checking ||
            state.locationStatus == RunLocationStatus.ready);
  }

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.paddingOf(context).top;
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final panelHeight = RunStatsPanel.contentHeight + bottomInset;
    final barTop = topInset + 20;
    final badgeTop = barTop + RunTopBar.height + 20;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: AppPalette.transparent,
      ),
      child: MultiBlocListener(
        listeners: [
          BlocListener<RunCubit, RunState>(
            listenWhen: (previous, current) =>
                previous.locationStatus != current.locationStatus,
            listener: (context, state) =>
                context.showRunLocationMessage(state.locationStatus),
          ),
          BlocListener<RunCubit, RunState>(
            listenWhen: (previous, current) =>
                previous.position == null && current.position != null,
            listener: (context, state) {
              final fix = state.position;
              if (fix != null) _moveTo(fix, zoom: MapConfig.followZoom);
            },
          ),
        ],
        child: Scaffold(
          backgroundColor: AppPalette.bgSurfaceNeutral,
          body: BlocBuilder<RunCubit, RunState>(
            builder: (context, state) {
              return Stack(
                children: [
                  // Peta berhenti 24 di bawah puncak panel, supaya sudut
                  // melengkung panel tetap berlatar peta.
                  Positioned.fill(
                    bottom: panelHeight - 24,
                    child: _waitingForPosition(state)
                        ? const _MapLoading()
                        : RunMapView(
                            controller: _mapController,
                            position: state.position,
                            onMapReady: _handleMapReady,
                          ),
                  ),
                  Positioned(
                    top: barTop,
                    left: 20,
                    right: 20,
                    child: RunTopBar(
                      activityType: state.activityType,
                      onBack: () => Navigator.of(context).maybePop(),
                      onTypeTap: () => _selectType(state),
                      onSettingsTap: () => _showUnavailable('Run settings'),
                    ),
                  ),
                  Positioned(
                    top: badgeTop,
                    left: 20,
                    child: RunChallengeButton(
                      onTap: () => _showUnavailable('Challenge'),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: panelHeight,
                    height: RunFloatingControls.height,
                    child: RunFloatingControls(
                      accuracyMeters: state.position?.accuracyMeters,
                      onLayersTap: () => _showUnavailable('Map layers'),
                      onLocateTap: () => _onLocateTap(state),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: panelHeight + 4,
                    child: const Center(child: RunMapAttribution()),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: RunStatsPanel(
                      distanceKm: state.distanceKm,
                      durationSeconds: state.durationSeconds,
                      paceSecondsPerKm: state.paceSecondsPerKm,
                      calories: state.calories,
                      goal: state.goal,
                      onGoalTap: () => _openGoalSheet(state),
                      onStartRun: () => _startRun(state),
                    ),
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

class _MapLoading extends StatelessWidget {
  const _MapLoading();

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: AppPalette.bgSurfaceNeutral,
      child: Center(
        child: CircularProgressIndicator(color: AppPalette.bgFillPrimary),
      ),
    );
  }
}

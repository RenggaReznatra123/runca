import 'package:flutter/material.dart';

import 'package:runca/ui/color.dart';

import '../models/run_goal.dart';
import '../models/run_split.dart';
import 'run_expanded_panel.dart';
import 'run_metrics.dart';
import 'run_panel_buttons.dart';
import 'run_panel_shell.dart';

/// Panel bawah saat lari berjalan, dijeda, atau terkunci. Tingginya mengikuti
/// jari saat digeser ke atas (sampai layar penuh) atau ke bawah.
class RunTrackingPanel extends StatefulWidget {
  const RunTrackingPanel({
    super.key,
    required this.distanceKm,
    required this.durationSeconds,
    required this.paceSecondsPerKm,
    required this.calories,
    required this.goal,
    required this.splits,
    required this.isPaused,
    required this.isLocked,
    required this.onPause,
    required this.onResume,
    required this.onLock,
    required this.onUnlock,
    required this.onFinish,
  });

  final double distanceKm;
  final int durationSeconds;
  final int? paceSecondsPerKm;
  final int calories;
  final RunGoal? goal;
  final List<RunSplit> splits;
  final bool isPaused;
  final bool isLocked;
  final VoidCallback onPause;
  final VoidCallback onResume;
  final VoidCallback onLock;
  final VoidCallback onUnlock;
  final VoidCallback onFinish;

  @override
  State<RunTrackingPanel> createState() => _RunTrackingPanelState();
}

class _RunTrackingPanelState extends State<RunTrackingPanel>
    with SingleTickerProviderStateMixin {
  // Kecepatan swipe minimum (px/detik) supaya dianggap lemparan.
  static const double _flingVelocity = 300;

  // Jarak tombol ke tepi bawah saat panel kecil (di atas area gesture sistem).
  static const double _collapsedButtonsBottom = 16;

  // 0 = panel kecil, 1 = layar penuh. Nilainya mengikuti jari saat digeser.
  late final AnimationController _expansion = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 300),
  );

  @override
  void didUpdateWidget(covariant RunTrackingPanel oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Layar terkunci selalu tampil sebagai panel kecil.
    if (!oldWidget.isLocked && widget.isLocked) {
      _expansion.animateTo(0, curve: Curves.easeOutCubic);
    }
  }

  @override
  void dispose() {
    _expansion.dispose();
    super.dispose();
  }

  void _onDragUpdate(DragUpdateDetails details, double travel) {
    _expansion.value -= details.delta.dy / travel;
  }

  /// Jari dilepas: lemparan cepat diteruskan, kalau pelan panel menempel ke
  /// posisi terdekat.
  void _settle(double velocity, double travel) {
    if (velocity.abs() > _flingVelocity) {
      _expansion.fling(velocity: -velocity / travel);
      return;
    }

    _expansion.animateTo(
      _expansion.value > 0.5 ? 1 : 0,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final collapsedHeight = RunPanelShell.contentHeight + bottomInset;
    final travel = size.height - collapsedHeight;
    final locked = widget.isLocked;

    return GestureDetector(
      onVerticalDragUpdate: locked ? null : (d) => _onDragUpdate(d, travel),
      onVerticalDragEnd: locked
          ? null
          : (d) => _settle(d.primaryVelocity ?? 0, travel),
      onVerticalDragCancel: locked ? null : () => _settle(0, travel),
      child: AnimatedBuilder(
        animation: _expansion,
        builder: (context, _) {
          final t = _expansion.value;
          final collapsedOpacity = (1 - t / 0.4).clamp(0.0, 1.0).toDouble();
          final expandedOpacity = ((t - 0.3) / 0.7).clamp(0.0, 1.0).toDouble();
          final buttonsBottom =
              _collapsedButtonsBottom +
              (RunExpandedPanel.buttonsBottom - _collapsedButtonsBottom) * t;

          return Container(
            height: collapsedHeight + travel * t,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: AppPalette.baseWhite,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(24 * (1 - t)),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppPalette.baseBlack.withValues(alpha: 0.12),
                  blurRadius: 24,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: Stack(
              children: [
                // Isi panel kecil: menempel di atas, memudar saat ditarik.
                Positioned(
                  left: 0,
                  right: 0,
                  top: 0,
                  height: collapsedHeight,
                  child: Opacity(
                    opacity: collapsedOpacity,
                    child: RunPanelShell(
                      child: RunMetrics(
                        distanceKm: widget.distanceKm,
                        durationSeconds: widget.durationSeconds,
                        paceSecondsPerKm: widget.paceSecondsPerKm,
                        calories: widget.calories,
                        goal: widget.goal,
                        highlighted: widget.isPaused,
                      ),
                    ),
                  ),
                ),
                // Isi layar penuh: menempel di bawah, muncul saat ditarik.
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  height: size.height,
                  child: IgnorePointer(
                    ignoring: t < 0.5,
                    child: Opacity(
                      opacity: expandedOpacity,
                      child: RunExpandedPanel(
                        distanceKm: widget.distanceKm,
                        durationSeconds: widget.durationSeconds,
                        paceSecondsPerKm: widget.paceSecondsPerKm,
                        calories: widget.calories,
                        splits: widget.splits,
                        isPaused: widget.isPaused,
                      ),
                    ),
                  ),
                ),
                // Tombol selalu tampil, hanya bergeser sedikit.
                Positioned(
                  left: 20,
                  right: 20,
                  bottom: bottomInset + buttonsBottom,
                  height: RunPanelButtons.height,
                  child: RunPanelButtons(
                    isPaused: widget.isPaused,
                    isLocked: locked,
                    onPause: widget.onPause,
                    onResume: widget.onResume,
                    onLock: widget.onLock,
                    onUnlock: widget.onUnlock,
                    onFinish: widget.onFinish,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
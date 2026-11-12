import 'package:flutter/material.dart';

import 'package:runca/ui/color.dart';

import '../models/run_split.dart';
import 'run_expanded_metrics.dart';
import 'run_page_dots.dart';
import 'run_panel_buttons.dart';
import 'run_splits_view.dart';

/// Isi layar penuh: dua halaman (angka dan Splits) yang digeser ke kiri atau
/// kanan, dan titik penanda. Baris tombol dipasang terpisah oleh
/// RunTrackingPanel, jadi di bawah sini disisakan ruang untuknya.
class RunExpandedPanel extends StatefulWidget {
  const RunExpandedPanel({
    super.key,
    required this.distanceKm,
    required this.durationSeconds,
    required this.paceSecondsPerKm,
    required this.calories,
    required this.splits,
    required this.autoLapEnabled,
    required this.isPaused,
  });

  /// Jarak tombol ke tepi bawah saat layar penuh (di atas area gesture sistem).
  static const double buttonsBottom = 24;

  static const double _dotsToButtonsGap = 27;

  final double distanceKm;
  final int durationSeconds;
  final int? paceSecondsPerKm;
  final int calories;
  final List<RunSplit> splits;
  final bool autoLapEnabled;
  final bool isPaused;

  @override
  State<RunExpandedPanel> createState() => _RunExpandedPanelState();
}

class _RunExpandedPanelState extends State<RunExpandedPanel> {
  static const int _pageCount = 2;

  final PageController _controller = PageController();
  int _page = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.paddingOf(context).top;
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Column(
      children: [
        SizedBox(height: topInset + 32),
        Container(
          width: 126,
          height: 4,
          decoration: BoxDecoration(
            color: AppPalette.profileMutedIcon,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(height: 30),
        Expanded(
          child: PageView(
            controller: _controller,
            onPageChanged: (page) => setState(() => _page = page),
            children: [
              RunExpandedMetrics(
                distanceKm: widget.distanceKm,
                durationSeconds: widget.durationSeconds,
                paceSecondsPerKm: widget.paceSecondsPerKm,
                calories: widget.calories,
                highlighted: widget.isPaused,
              ),
              RunSplitsView(
                splits: widget.splits,
                autoLapEnabled: widget.autoLapEnabled,
              ),
            ],
          ),
        ),
        RunPageDots(count: _pageCount, index: _page),
        SizedBox(
          height:
              RunExpandedPanel._dotsToButtonsGap +
              RunPanelButtons.height +
              RunExpandedPanel.buttonsBottom +
              bottomInset,
        ),
      ],
    );
  }
}

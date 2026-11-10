import 'package:flutter/material.dart';

import 'run_gps_chip.dart';
import 'run_side_controls.dart';

/// Chip GPS (kiri) dan tombol layer dan ke-lokasiku (kanan), menempel di atas
/// panel bawah. Dipasang di Stack dengan tinggi [height].
class RunFloatingControls extends StatelessWidget {
  const RunFloatingControls({
    super.key,
    required this.accuracyMeters,
    required this.onLayersTap,
    required this.onLocateTap,
  });

  static const double height = 132;
  static const double _bottomGap = 19;

  final double? accuracyMeters;
  final VoidCallback onLayersTap;
  final VoidCallback onLocateTap;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: 20,
          bottom: _bottomGap,
          child: RunGpsChip(accuracyMeters: accuracyMeters),
        ),
        Positioned(
          right: 20,
          bottom: _bottomGap,
          child: RunSideControls(
            onLayersTap: onLayersTap,
            onLocateTap: onLocateTap,
          ),
        ),
      ],
    );
  }
}
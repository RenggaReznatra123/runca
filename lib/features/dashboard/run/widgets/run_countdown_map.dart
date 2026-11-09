import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

import 'package:runca/ui/color.dart';

import '../models/location_fix.dart';
import 'run_map_view.dart';

/// Peta pudar sebagai latar layar countdown: tidak bisa disentuh, dan
/// memudar ke putih di bagian atas dan bawah.
class RunCountdownMap extends StatefulWidget {
  const RunCountdownMap({super.key, required this.position});

  final LocationFix? position;

  @override
  State<RunCountdownMap> createState() => _RunCountdownMapState();
}

class _RunCountdownMapState extends State<RunCountdownMap> {
  final MapController _controller = MapController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: ShaderMask(
        blendMode: BlendMode.dstIn,
        shaderCallback: (rect) => const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppPalette.transparent,
            AppPalette.baseWhite,
            AppPalette.baseWhite,
            AppPalette.transparent,
          ],
          stops: [0, 0.12, 0.88, 1],
        ).createShader(rect),
        child: Opacity(
          opacity: 0.2,
          child: RunMapView(
            controller: _controller,
            position: widget.position,
            onMapReady: () {},
          ),
        ),
      ),
    );
  }
}

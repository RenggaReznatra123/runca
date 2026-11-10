import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import 'package:runca/config/map_config.dart';
import 'package:runca/ui/color.dart';
import 'package:runca/ui/shared_view/app_image.dart';

import '../models/activity_model.dart';

/// Peta kecil yang menggambar rute dan tidak bisa digeser.
/// Kalau rute kurang dari dua titik, tampil gambar [imagePath] atau placeholder.
class RouteMapPreview extends StatelessWidget {
  const RouteMapPreview({
    super.key,
    required this.route,
    required this.height,
    this.width = double.infinity,
    this.imagePath,
    this.showStart = false,
    this.strokeWidth = 3,
  });

  final List<RoutePoint> route;
  final String? imagePath;
  final double width;
  final double height;

  /// Tampilkan titik biru di awal rute.
  final bool showStart;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    if (route.length < 2) {
      return AppImage(
        path: imagePath,
        width: width,
        height: height,
        placeholder: _placeholder(),
      );
    }

    final points = [
      for (final point in route) LatLng(point.latitude, point.longitude),
    ];

    return SizedBox(
      width: width,
      height: height,
      child: IgnorePointer(
        child: FlutterMap(
          options: MapOptions(
            initialCameraFit: CameraFit.bounds(
              bounds: LatLngBounds.fromPoints(points),
              padding: const EdgeInsets.all(24),
              maxZoom: 18,
            ),
            interactionOptions: const InteractionOptions(
              flags: InteractiveFlag.none,
            ),
          ),
          children: [
            TileLayer(
              urlTemplate: MapConfig.tileUrlTemplate,
              userAgentPackageName: MapConfig.userAgentPackageName,
              maxNativeZoom: 19,
            ),
            PolylineLayer(
              polylines: [
                Polyline(
                  points: points,
                  strokeWidth: strokeWidth,
                  color: AppPalette.profileAccent,
                ),
              ],
            ),
            if (showStart)
              MarkerLayer(
                markers: [
                  Marker(
                    point: points.first,
                    width: 18,
                    height: 18,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: AppPalette.bgFillInfo,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppPalette.baseWhite,
                          width: 3,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      width: width,
      height: height,
      color: AppPalette.bgSurfaceNeutral,
      alignment: Alignment.center,
      child: const Icon(
        Icons.map_outlined,
        size: 32,
        color: AppPalette.textNeutralSecondary,
      ),
    );
  }
}

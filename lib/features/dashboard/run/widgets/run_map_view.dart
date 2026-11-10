import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import 'package:runca/config/map_config.dart';
import 'package:runca/ui/color.dart';

import '../models/location_fix.dart';

/// Peta nyata dengan titik lokasi pengguna, lingkaran akurasi, dan (kalau
/// ada) garis rute.
class RunMapView extends StatelessWidget {
  const RunMapView({
    super.key,
    required this.controller,
    required this.position,
    required this.onMapReady,
    this.route = const [],
    this.onGesture,
  });

  final MapController controller;
  final LocationFix? position;
  final VoidCallback onMapReady;

  /// Titik-titik rute. Garis baru tergambar kalau ada minimal dua titik.
  final List<LocationFix> route;

  /// Dipanggil saat pengguna menggeser atau men-zoom peta dengan jarinya.
  final VoidCallback? onGesture;

  @override
  Widget build(BuildContext context) {
    final fix = position;
    final point = fix == null ? null : LatLng(fix.latitude, fix.longitude);

    return FlutterMap(
      mapController: controller,
      options: MapOptions(
        initialCenter:
            point ??
            LatLng(MapConfig.defaultLatitude, MapConfig.defaultLongitude),
        initialZoom: point == null
            ? MapConfig.defaultZoom
            : MapConfig.followZoom,
        maxZoom: MapConfig.maxZoom,
        interactionOptions: const InteractionOptions(
          flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
        ),
        onMapReady: onMapReady,
        onPositionChanged: (camera, hasGesture) {
          if (hasGesture) onGesture?.call();
        },
      ),
      children: [
        TileLayer(
          urlTemplate: MapConfig.tileUrlTemplate,
          userAgentPackageName: MapConfig.userAgentPackageName,
          maxNativeZoom: 19,
        ),
        if (route.length >= 2)
          PolylineLayer(
            polylines: [
              Polyline(
                points: [
                  for (final item in route)
                    LatLng(item.latitude, item.longitude),
                ],
                strokeWidth: 4,
                color: AppPalette.profileAccent,
              ),
            ],
          ),
        if (point != null && fix != null)
          CircleLayer(
            circles: [
              CircleMarker(
                point: point,
                radius: fix.accuracyMeters,
                useRadiusInMeter: true,
                color: AppPalette.bgFillInfo.withValues(alpha: 0.15),
                borderColor: AppPalette.bgFillInfo.withValues(alpha: 0.35),
                borderStrokeWidth: 1,
              ),
            ],
          ),
        if (point != null)
          MarkerLayer(
            markers: [
              Marker(
                point: point,
                width: 22,
                height: 22,
                child: const _LocationDot(),
              ),
            ],
          ),
      ],
    );
  }
}

class _LocationDot extends StatelessWidget {
  const _LocationDot();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppPalette.bgFillInfo,
        shape: BoxShape.circle,
        border: Border.all(color: AppPalette.baseWhite, width: 3),
        boxShadow: [
          BoxShadow(
            color: AppPalette.baseBlack.withValues(alpha: 0.25),
            blurRadius: 4,
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

import 'package:runca/features/dashboard/activity/models/activity_model.dart';
import 'package:runca/features/dashboard/activity/widgets/route_map_preview.dart';
import 'package:runca/ui/color.dart';

/// Peta rute di layar ringkasan, dengan tombol kamera di pojok kanan bawah.
class RunSummaryMap extends StatelessWidget {
  const RunSummaryMap({
    super.key,
    required this.route,
    required this.onCameraTap,
  });

  final List<RoutePoint> route;
  final VoidCallback onCameraTap;

  static const double _height = 188;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        height: _height,
        child: Stack(
          children: [
            Positioned.fill(
              child: RouteMapPreview(
                route: route,
                height: _height,
                showStart: true,
                strokeWidth: 4,
              ),
            ),
            Positioned(
              right: 12,
              bottom: 12,
              child: Material(
                color: AppPalette.baseWhite,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: AppPalette.borderNeutral),
                ),
                child: InkWell(
                  onTap: onCameraTap,
                  borderRadius: BorderRadius.circular(12),
                  child: const SizedBox(
                    width: 56,
                    height: 56,
                    child: Icon(
                      Icons.photo_camera_outlined,
                      color: AppPalette.profileMutedIcon,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

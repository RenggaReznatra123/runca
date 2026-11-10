import 'package:flutter/material.dart';

import '../models/activity_model.dart';
import 'route_map_preview.dart';

class ActivityMapThumbnail extends StatelessWidget {
  const ActivityMapThumbnail({
    this.imagePath,
    this.route = const [],
    super.key,
  });

  final String? imagePath;
  final List<RoutePoint> route;

  static const double _width = 168;
  static const double _height = 116;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: RouteMapPreview(
        route: route,
        imagePath: imagePath,
        width: _width,
        height: _height,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:runca/ui/color.dart';
import 'package:runca/ui/shared_view/app_image.dart';

class ActivityMapThumbnail extends StatelessWidget {
  const ActivityMapThumbnail({this.imagePath, super.key});

  final String? imagePath;

  static const double _width = 168;
  static const double _height = 116;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: AppImage(
        path: imagePath,
        width: _width,
        height: _height,
        placeholder: _placeholder(),
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      width: _width,
      height: _height,
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

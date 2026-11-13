import 'package:flutter/material.dart';

import 'package:runca/ui/shared_view/app_image.dart';

import '../models/activity_model.dart';
import 'activity_circle_button.dart';
import 'activity_more_menu.dart';
import 'route_map_preview.dart';

/// Peta rute layar penuh dengan tombol kembali, share, dan menu di atasnya,
/// serta foto aktivitas (kalau ada) di kanan bawah.
/// [bottomOffset] menyisakan ruang untuk sheet di bawah.
class ActivityDetailMap extends StatelessWidget {
  const ActivityDetailMap({
    super.key,
    required this.route,
    required this.bottomOffset,
    required this.onBack,
    required this.onShare,
    required this.onMenuSelected,
    this.photoPath,
  });

  // Ukuran dan jarak foto dari Figma: 85 x 82, 29 di atas puncak sheet
  // (sheet menimpa peta 24).
  static const double _photoWidth = 85;
  static const double _photoHeight = 82;
  static const double _photoAboveMap = 53;

  final List<RoutePoint> route;
  final double bottomOffset;
  final VoidCallback onBack;
  final VoidCallback onShare;
  final ValueChanged<ActivityMenuAction> onMenuSelected;

  /// Foto aktivitas. Null atau kosong berarti tidak ditampilkan.
  final String? photoPath;

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.paddingOf(context).top;
    final photo = photoPath;

    return Stack(
      children: [
        Positioned.fill(
          bottom: bottomOffset,
          child: LayoutBuilder(
            builder: (context, box) => RouteMapPreview(
              route: route,
              height: box.maxHeight,
              showStart: true,
              strokeWidth: 4,
            ),
          ),
        ),
        if (photo != null && photo.isNotEmpty)
          Positioned(
            right: 20,
            bottom: bottomOffset + _photoAboveMap,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: AppImage(
                path: photo,
                width: _photoWidth,
                height: _photoHeight,
              ),
            ),
          ),
        Positioned(
          top: topInset + 16,
          left: 20,
          child: ActivityCircleButton(
            icon: Icons.arrow_back_ios_new_rounded,
            onTap: onBack,
          ),
        ),
        Positioned(
          top: topInset + 16,
          right: 20,
          child: Row(
            children: [
              ActivityCircleButton(icon: Icons.share_outlined, onTap: onShare),
              const SizedBox(width: 12),
              ActivityMoreMenu(onSelected: onMenuSelected),
            ],
          ),
        ),
      ],
    );
  }
}

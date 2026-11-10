import 'package:flutter/material.dart';

import '../models/activity_model.dart';
import 'activity_circle_button.dart';
import 'route_map_preview.dart';

/// Peta rute layar penuh dengan tombol kembali, share, dan menu di atasnya.
/// [bottomOffset] menyisakan ruang untuk sheet di bawah.
class ActivityDetailMap extends StatelessWidget {
  const ActivityDetailMap({
    super.key,
    required this.route,
    required this.bottomOffset,
    required this.onBack,
    required this.onShare,
    required this.onMore,
  });

  final List<RoutePoint> route;
  final double bottomOffset;
  final VoidCallback onBack;
  final VoidCallback onShare;
  final VoidCallback onMore;

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.paddingOf(context).top;

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
              ActivityCircleButton(
                icon: Icons.more_vert_rounded,
                onTap: onMore,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

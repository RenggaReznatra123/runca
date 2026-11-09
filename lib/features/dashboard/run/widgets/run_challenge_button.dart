import 'package:flutter/material.dart';

import 'package:runca/config/app_assets.dart';
import 'package:runca/ui/color.dart';
import 'package:runca/ui/shared_view/app_image.dart';

/// Tombol bulat bergambar badge challenge di kiri peta.
class RunChallengeButton extends StatelessWidget {
  const RunChallengeButton({super.key, required this.onTap});

  static const double size = 76;

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppPalette.baseWhite,
      shape: const CircleBorder(),
      elevation: 4,
      shadowColor: AppPalette.baseBlack.withValues(alpha: 0.3),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: size,
          height: size,
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: ClipOval(child: AppImage(path: AppAssets.challengeImage)),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import 'package:runca/ui/color.dart';

/// Tombol bulat putih untuk di atas peta (kembali, share, menu).
class ActivityCircleButton extends StatelessWidget {
  const ActivityCircleButton({
    super.key,
    required this.icon,
    required this.onTap,
  });

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppPalette.baseWhite,
      elevation: 2,
      shadowColor: AppPalette.baseBlack.withValues(alpha: 0.2),
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 48,
          height: 48,
          child: Icon(icon, size: 20, color: AppPalette.textNeutralPrimary),
        ),
      ),
    );
  }
}

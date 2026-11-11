import 'package:flutter/material.dart';

import 'package:runca/features/dashboard/activity/models/activity_model.dart';
import 'package:runca/ui/color.dart';
import 'package:runca/ui/typography.dart';

import 'activity_type_presentation.dart';

/// Bar atas layar Setup Treadmill: tombol back, pil jenis aktivitas, dan
/// pengaturan. Tanpa kapsul putih seperti bar di atas peta.
class TreadmillTopBar extends StatelessWidget {
  const TreadmillTopBar({
    super.key,
    required this.activityType,
    required this.onBack,
    required this.onTypeTap,
    required this.onSettingsTap,
  });

  static const double height = 42;

  final ActivityType activityType;
  final VoidCallback onBack;
  final VoidCallback onTypeTap;
  final VoidCallback onSettingsTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Row(
        children: [
          _OutlinedCircle(
            icon: Icons.arrow_back_ios_new_rounded,
            iconSize: 18,
            onTap: onBack,
          ),
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 172),
                child: _TypePill(type: activityType, onTap: onTypeTap),
              ),
            ),
          ),
          _OutlinedCircle(
            icon: Icons.settings_outlined,
            iconSize: 22,
            onTap: onSettingsTap,
          ),
        ],
      ),
    );
  }
}

class _OutlinedCircle extends StatelessWidget {
  const _OutlinedCircle({
    required this.icon,
    required this.iconSize,
    required this.onTap,
  });

  final IconData icon;
  final double iconSize;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppPalette.baseWhite,
      shape: const CircleBorder(
        side: BorderSide(color: AppPalette.borderNeutral),
      ),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 40,
          height: 40,
          child: Icon(
            icon,
            size: iconSize,
            color: AppPalette.iconNeutralPrimary,
          ),
        ),
      ),
    );
  }
}

class _TypePill extends StatelessWidget {
  const _TypePill({required this.type, required this.onTap});

  final ActivityType type;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppPalette.baseWhite,
      shape: const StadiumBorder(
        side: BorderSide(color: AppPalette.borderNeutral),
      ),
      child: InkWell(
        customBorder: const StadiumBorder(),
        onTap: onTap,
        child: SizedBox(
          height: TreadmillTopBar.height,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(type.icon, size: 22, color: AppPalette.profileAccent),
              const SizedBox(width: 8),
              Text(
                type.label,
                style: AppTypography.titleSmall(
                  color: AppPalette.profileAccent,
                ).copyWith(fontWeight: AppTypography.semiBold),
              ),
              const SizedBox(width: 6),
              const Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 22,
                color: AppPalette.iconNeutralPrimary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

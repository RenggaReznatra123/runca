import 'package:flutter/material.dart';

import 'package:runca/features/dashboard/activity/models/activity_model.dart';
import 'package:runca/ui/color.dart';
import 'package:runca/ui/typography.dart';

/// Bar melayang di atas peta: back, pemilih aktivitas, dan pengaturan.
class RunTopBar extends StatelessWidget {
  const RunTopBar({
    super.key,
    required this.activityType,
    required this.onBack,
    required this.onTypeTap,
    required this.onSettingsTap,
  });

  static const double height = 64;

  final ActivityType activityType;
  final VoidCallback onBack;
  final VoidCallback onTypeTap;
  final VoidCallback onSettingsTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppPalette.baseWhite.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: AppPalette.baseBlack.withValues(alpha: 0.08),
            blurRadius: 12,
          ),
        ],
      ),
      child: Row(
        children: [
          _CircleButton(icon: Icons.arrow_back_ios_new_rounded, onTap: onBack),
          const SizedBox(width: 12),
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(minWidth: 140, maxWidth: 181),
                child: _TypePill(type: activityType, onTap: onTypeTap),
              ),
            ),
          ),
          const SizedBox(width: 12),
          _CircleButton(icon: Icons.settings_outlined, onTap: onSettingsTap),
        ],
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  const _CircleButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppPalette.baseWhite,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 48,
          height: 48,
          child: Icon(icon, size: 22, color: AppPalette.iconNeutralPrimary),
        ),
      ),
    );
  }
}

class _TypePill extends StatelessWidget {
  const _TypePill({required this.type, required this.onTap});

  final ActivityType type;
  final VoidCallback onTap;

  IconData get _icon => switch (type) {
    ActivityType.running => Icons.directions_run_rounded,
    ActivityType.treadmill => Icons.fitness_center_rounded,
    ActivityType.cycling => Icons.directions_bike_rounded,
  };

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppPalette.baseWhite,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: SizedBox(
          height: 48,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(_icon, size: 22, color: AppPalette.profileAccent),
              const SizedBox(width: 8),
              Text(
                type.label,
                style: AppTypography.titleSmall(
                  color: AppPalette.profileAccent,
                ).copyWith(fontWeight: AppTypography.semiBold),
              ),
              const SizedBox(width: 8),
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

import 'package:flutter/material.dart';

import 'package:runca/features/dashboard/activity/models/activity_model.dart';
import 'package:runca/ui/color.dart';
import 'package:runca/ui/typography.dart';

import 'activity_type_presentation.dart';

/// Bar melayang di atas peta: tombol kiri, label aktivitas, dan pengaturan.
/// Kalau [onTypeTap] ada, label berupa pil yang bisa diketuk (layar Setup).
/// Kalau null, label hanya tulisan biasa (layar Tracking).
class RunTopBar extends StatelessWidget {
  const RunTopBar({
    super.key,
    required this.activityType,
    required this.onBack,
    required this.onSettingsTap,
    this.onTypeTap,
    this.leadingIcon = Icons.arrow_back_ios_new_rounded,
  });

  static const double height = 64;

  final ActivityType activityType;
  final VoidCallback onBack;
  final VoidCallback onSettingsTap;
  final VoidCallback? onTypeTap;
  final IconData leadingIcon;

  @override
  Widget build(BuildContext context) {
    final typeTap = onTypeTap;

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
          _CircleButton(icon: leadingIcon, onTap: onBack),
          const SizedBox(width: 12),
          Expanded(
            child: Center(
              child: typeTap == null
                  ? _TypeLabel(type: activityType)
                  : ConstrainedBox(
                      constraints: const BoxConstraints(
                        minWidth: 140,
                        maxWidth: 181,
                      ),
                      child: _TypePill(type: activityType, onTap: typeTap),
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

class _TypeLabel extends StatelessWidget {
  const _TypeLabel({required this.type});

  final ActivityType type;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(type.icon, size: 22, color: AppPalette.profileAccent),
        const SizedBox(width: 8),
        Text(
          type.label,
          style: AppTypography.titleSmall(
            color: AppPalette.profileAccent,
          ).copyWith(fontWeight: AppTypography.semiBold),
        ),
      ],
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
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: SizedBox(
          height: 48,
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

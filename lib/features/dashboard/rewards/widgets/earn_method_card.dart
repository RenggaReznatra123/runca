import 'package:flutter/material.dart';

import 'package:runca/ui/color.dart';
import 'package:runca/ui/typography.dart';

import '../models/reward_model.dart';

/// Kartu satu cara mendapatkan PlaCoins.
class EarnMethodCard extends StatelessWidget {
  const EarnMethodCard({super.key, required this.method, required this.onTap});

  final EarnMethod method;
  final VoidCallback onTap;

  /// Ikon dan warna per jenis (tampilan, jadi dipetakan di widget).
  static ({IconData icon, Color color, Color background}) _styleOf(
    EarnMethodType type,
  ) {
    switch (type) {
      case EarnMethodType.events:
        return (
          icon: Icons.emoji_events_outlined,
          color: AppPalette.achievementGold,
          background: AppPalette.bgSurfaceWarning,
        );
      case EarnMethodType.dailyRuns:
        return (
          icon: Icons.directions_run_rounded,
          color: AppPalette.profileAccent,
          background: AppPalette.bgSurfacePrimary,
        );
      case EarnMethodType.streak:
        return (
          icon: Icons.local_fire_department_rounded,
          color: AppPalette.iconSecondary,
          background: AppPalette.bgSurfaceDanger,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final style = _styleOf(method.type);

    return Material(
      color: AppPalette.bgPrimary,
      borderRadius: BorderRadius.circular(20),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 14, 16, 14),
          child: Row(
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  color: style.background,
                  shape: BoxShape.circle,
                ),
                child: SizedBox(
                  width: 48,
                  height: 48,
                  child: Icon(style.icon, size: 24, color: style.color),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      method.title,
                      style: AppTypography.titleSmall(
                        color: AppPalette.profileDarkText,
                      ).copyWith(fontWeight: AppTypography.semiBold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      method.description,
                      style: AppTypography.bodyMedium(
                        color: AppPalette.textNeutralSecondary,
                      ).copyWith(height: 18 / 14),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.chevron_right_rounded,
                size: 24,
                color: AppPalette.profileMutedIcon,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

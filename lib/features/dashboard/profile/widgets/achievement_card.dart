import 'package:flutter/material.dart';

import 'package:runca/ui/color.dart';
import 'package:runca/ui/shared_view/app_image.dart';
import 'package:runca/ui/typography.dart';
import 'package:runca/utility/format_utils.dart';

import '../models/profile_model.dart';

/// Kartu satu badge di halaman Achievements. Badge yang belum selesai
/// (tanpa tanggal) tampil sebagai terkunci.
class AchievementCard extends StatelessWidget {
  const AchievementCard({super.key, required this.achievement});

  final AchievementModel achievement;

  static const double _badgeSize = 64;

  @override
  Widget build(BuildContext context) {
    final completedAt = achievement.completedAt;
    final isLocked = completedAt == null;

    return Container(
      padding: const EdgeInsets.fromLTRB(8, 24, 8, 0),
      decoration: BoxDecoration(
        color: AppPalette.bgSurfaceNeutral,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          AppImage(
            path: achievement.iconAsset,
            width: _badgeSize,
            height: _badgeSize,
            fit: BoxFit.contain,
            placeholder: const _BadgeFallback(),
          ),
          const SizedBox(height: 10),
          Text(
            achievement.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style:
                AppTypography.titleSmall(
                  color: isLocked
                      ? AppPalette.profileMutedText
                      : AppPalette.profileDarkText,
                ).copyWith(
                  fontWeight: isLocked
                      ? AppTypography.regular
                      : AppTypography.semiBold,
                ),
          ),
          SizedBox(height: isLocked ? 4 : 2),
          if (isLocked)
            Text(
              'Not yet',
              style: AppTypography.bodySmall(
                color: AppPalette.textNeutralSecondary,
              ),
            )
          else ...[
            Text(
              'Completed',
              style: AppTypography.bodySmall(
                color: AppPalette.profileMutedText,
              ),
            ),
            Text(
              AppFormat.shortDate(completedAt),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.bodySmall(
                color: AppPalette.profileMutedText,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Pengganti sementara kalau file gambar badge belum ada.
class _BadgeFallback extends StatelessWidget {
  const _BadgeFallback();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: AchievementCard._badgeSize,
      height: AchievementCard._badgeSize,
      child: Icon(
        Icons.workspace_premium_rounded,
        size: 44,
        color: AppPalette.achievementGold,
      ),
    );
  }
}
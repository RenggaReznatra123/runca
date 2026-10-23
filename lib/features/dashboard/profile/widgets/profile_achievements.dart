import 'package:flutter/material.dart';
import 'package:runca/features/dashboard/profile/models/profile_model.dart';
import 'package:runca/ui/color.dart';
import 'package:runca/ui/typography.dart';
import 'package:runca/utility/format_utils.dart';

class ProfileAchievements extends StatelessWidget {
  const ProfileAchievements({
    super.key,
    required this.achievements,
    required this.onSeeAllTap,
  });

  final List<AchievementModel> achievements;
  final VoidCallback onSeeAllTap;

  static const Color _cardColor = Color(0xFFF8F8F8);
  static const Color _accentBlue = Color(0xFF0284C7);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Achievements',
                style: AppTypography.titleMedium(
                  color: AppPalette.textNeutralPrimary,
                ).copyWith(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
            GestureDetector(
              onTap: onSeeAllTap,
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  'See all',
                  style: AppTypography.bodySmall(
                    color: _accentBlue,
                  ).copyWith(fontSize: 14),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        if (achievements.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: _cardColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              'No achievements yet. Keep running!',
              textAlign: TextAlign.center,
              style: AppTypography.bodyMedium(
                color: AppPalette.textNeutralSecondary,
              ),
            ),
          )
        else
          SizedBox(
            height: 151,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: achievements.length,
              separatorBuilder: (_, _) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                return _AchievementCard(
                  achievement: achievements[index],
                  imagePath: achievements[index].iconAsset,
                );
              },
            ),
          ),
      ],
    );
  }
}

class _AchievementCard extends StatelessWidget {
  const _AchievementCard({required this.achievement, required this.imagePath});

  final AchievementModel achievement;
  final String? imagePath;

  static const Color _cardColor = Color(0xFFF8F8F8);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 138,
      padding: const EdgeInsets.fromLTRB(8, 10, 8, 9),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: imagePath != null && imagePath!.isNotEmpty
                  ? Image.asset(
                      imagePath!,
                      width: 82,
                      height: 82,
                      fit: BoxFit.contain,
                      errorBuilder: (_, _, _) => _medalFallback(),
                    )
                  : _medalFallback(),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            achievement.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: AppTypography.bodyMedium(
              color: AppPalette.textNeutralPrimary,
            ).copyWith(fontSize: 12),
          ),
          const SizedBox(height: 5),
          Text(
            'Completed',
            style: AppTypography.bodySmall(
              color: AppPalette.textNeutralSecondary,
            ).copyWith(fontSize: 10),
          ),
          const SizedBox(height: 3),
          Text(
            AppFormat.fullDate(achievement.completedAt),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.bodySmall(
              color: AppPalette.textNeutralSecondary,
            ).copyWith(fontSize: 10),
          ),
        ],
      ),
    );
  }

  Widget _medalFallback() {
    return const Icon(
      Icons.workspace_premium_rounded,
      size: 54,
      color: Color(0xFFF5B82E),
    );
  }
}

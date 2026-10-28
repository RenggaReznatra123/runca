import 'package:flutter/material.dart';
import 'package:runca/config/app_assets.dart';
import 'package:runca/features/dashboard/profile/models/profile_model.dart';
import 'package:runca/features/dashboard/profile/widgets/profile_achievements.dart';
import 'package:runca/features/dashboard/profile/widgets/profile_header.dart';
import 'package:runca/features/dashboard/profile/widgets/profile_info.dart';
import 'package:runca/features/dashboard/profile/widgets/profile_stat_card.dart';
import 'package:runca/features/dashboard/profile/widgets/profile_vouchers.dart';
import 'package:runca/ui/color.dart';
import 'package:runca/ui/typography.dart';
import 'package:runca/utility/format_utils.dart';

class ProfileContent extends StatelessWidget {
  const ProfileContent({
    required this.data,
    required this.hasRefreshError,
    required this.onSettingsTap,
    required this.onEditProfileTap,
    required this.onCoinsTap,
    required this.onRankTap,
    required this.onSeeAllAchievements,
    required this.onVouchersTap,
    super.key,
  });

  final ProfileData data;
  final bool hasRefreshError;
  final VoidCallback onSettingsTap;
  final VoidCallback onEditProfileTap;
  final VoidCallback onCoinsTap;
  final VoidCallback onRankTap;
  final VoidCallback onSeeAllAchievements;
  final VoidCallback onVouchersTap;

  @override
  Widget build(BuildContext context) {
    final profile = data.profile;

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      children: [
        ProfileHeader(onSettingsTap: onSettingsTap),
        const SizedBox(height: 22),
        ProfileInfo(profile: profile, onEditTap: onEditProfileTap),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: ProfileStatCard(
                title: 'Your PlaCoins',
                value: AppFormat.thousands(profile.coins),
                imagePath: AppAssets.placoin,
                onTap: onCoinsTap,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ProfileStatCard(
                title: 'Your Rank',
                value: profile.rank > 0 ? AppFormat.integer(profile.rank) : '-',
                imagePath: AppAssets.rank,
                onTap: onRankTap,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ProfileAchievements(
          achievements: data.achievements,
          onSeeAllTap: onSeeAllAchievements,
        ),
        const SizedBox(height: 20),
        ProfileVouchers(onTap: onVouchersTap),
        if (hasRefreshError) ...[
          const SizedBox(height: 12),
          Text(
            'Some profile data could not be refreshed.',
            style: AppTypography.bodySmall(
              color: AppPalette.textNeutralSecondary,
            ),
          ),
        ],
      ],
    );
  }
}

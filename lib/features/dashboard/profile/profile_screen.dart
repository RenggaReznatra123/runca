import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:runca/features/dashboard/settings/settings_screen.dart';
import 'package:runca/config/app_assets.dart';
import 'package:runca/features/dashboard/profile/cubit/profile_cubit.dart';
import 'package:runca/features/dashboard/profile/cubit/profile_state.dart';
import 'package:runca/features/dashboard/profile/widgets/profile_achievements.dart';
import 'package:runca/features/dashboard/profile/widgets/profile_header.dart';
import 'package:runca/features/dashboard/profile/widgets/profile_info.dart';
import 'package:runca/features/dashboard/profile/widgets/profile_stat_card.dart';
import 'package:runca/features/dashboard/profile/widgets/profile_vouchers.dart';
import 'package:runca/ui/color.dart';
import 'package:runca/ui/typography.dart';
import 'package:runca/utility/format_utils.dart';
import 'package:runca/features/dashboard/home/leaderboard/leaderboard_screen.dart';
import 'package:runca/features/dashboard/rewards/rewards_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _showUnavailable(BuildContext context, String page) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('$page belum tersedia.'),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileCubit(),
      child: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: AppPalette.baseWhite,
            body: SafeArea(
              child: BlocBuilder<ProfileCubit, ProfileState>(
                builder: (context, state) {
                  final cubit = context.read<ProfileCubit>();

                  if (state.status == ProfileStatus.loading &&
                      state.data == null) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppPalette.bgFillPrimary,
                      ),
                    );
                  }

                  if (state.status == ProfileStatus.failure &&
                      state.data == null) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.cloud_off_outlined,
                              size: 48,
                              color: AppPalette.textNeutralSecondary,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Unable to load profile',
                              style: AppTypography.titleMedium(
                                color: AppPalette.textNeutralPrimary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Check your connection and try again.',
                              textAlign: TextAlign.center,
                              style: AppTypography.bodyMedium(
                                color: AppPalette.textNeutralSecondary,
                              ),
                            ),
                            const SizedBox(height: 16),
                            OutlinedButton(
                              onPressed: cubit.loadProfile,
                              child: const Text('Try Again'),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  final data = state.data;

                  if (data == null) {
                    return const Center(
                      child: Text('Profile data is unavailable.'),
                    );
                  }

                  final profile = data.profile;

                  return RefreshIndicator(
                    color: AppPalette.bgFillPrimary,
                    onRefresh: cubit.loadProfile,
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                      children: [
                        ProfileHeader(
                          onSettingsTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (_) => const SettingsScreen(),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 22),
                        ProfileInfo(
                          profile: profile,
                          onEditTap: () =>
                              _showUnavailable(context, 'Edit Profile'),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: ProfileStatCard(
                                title: 'Your PlaCoins',
                                value: AppFormat.thousands(profile.coins),
                                imagePath: AppAssets.placoin,
                                onTap: () async {
                                  final cubit = context.read<ProfileCubit>();
                                  await Navigator.of(context).push<void>(
                                    MaterialPageRoute<void>(
                                      builder: (_) => const RewardsScreen(),
                                    ),
                                  );
                                  if (!context.mounted || cubit.isClosed) return;
                                  await cubit.refresh();
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ProfileStatCard(
                                title: 'Your Rank',
                                value: profile.rank > 0
                                    ? '${profile.rank}'
                                    : '-',
                                imagePath: AppAssets.rank,
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute<void>(
                                      builder: (_) => const LeaderboardScreen(),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        ProfileAchievements(
                          achievements: data.achievements,
                          onSeeAllTap: () =>
                              _showUnavailable(context, 'All achievements'),
                        ),
                        const SizedBox(height: 20),
                        ProfileVouchers(
                          onTap: () => _showUnavailable(context, 'My Vouchers'),
                        ),
                        if (state.status == ProfileStatus.failure) ...[
                          const SizedBox(height: 12),
                          Text(
                            'Some profile data could not be refreshed.',
                            style: AppTypography.bodySmall(
                              color: AppPalette.textNeutralSecondary,
                            ),
                          ),
                        ],
                      ],
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

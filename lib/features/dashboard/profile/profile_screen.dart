import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:runca/features/dashboard/home/leaderboard/leaderboard_screen.dart';
import 'package:runca/features/dashboard/profile/cubit/profile_cubit.dart';
import 'package:runca/features/dashboard/profile/cubit/profile_state.dart';
import 'package:runca/features/dashboard/profile/models/profile_model.dart';
import 'package:runca/features/dashboard/profile/widgets/profile_content.dart';
import 'package:runca/features/dashboard/rewards/my_vouchers_screen.dart';
import 'package:runca/features/dashboard/rewards/rewards_screen.dart';
import 'package:runca/features/dashboard/settings/settings_screen.dart';
import 'package:runca/ui/color.dart';
import 'package:runca/ui/typography.dart';
import 'package:runca/utility/snackbar_extension.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _showUnavailable(BuildContext context, String page) {
    context.showUnavailableSnackbar(page, duration: const Duration(seconds: 2));
  }

  Future<void> _openRewards(BuildContext context, ProfileCubit cubit) async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(builder: (_) => const RewardsScreen()),
    );
    if (!context.mounted || cubit.isClosed) return;
    await cubit.refresh();
  }

  void _openVouchers(BuildContext context, ProfileCubit cubit) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => MyVouchersScreen(
          // Dari Profile: ganti halaman ini dengan Rewards, lalu muat ulang saldo saat kembali.
          onExploreRewards: () async {
            await Navigator.of(context).pushReplacement<void, void>(
              MaterialPageRoute<void>(builder: (_) => const RewardsScreen()),
            );
            if (!context.mounted || cubit.isClosed) return;
            await cubit.refresh();
          },
        ),
      ),
    );
  }

  void _openLeaderboard(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const LeaderboardScreen()));
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
                    return _ProfileLoadError(onRetry: cubit.loadProfile);
                  }

                  final ProfileData? data = state.data;

                  if (data == null) {
                    return const Center(
                      child: Text('Profile data is unavailable.'),
                    );
                  }

                  return RefreshIndicator(
                    color: AppPalette.bgFillPrimary,
                    onRefresh: cubit.loadProfile,
                    child: ProfileContent(
                      data: data,
                      hasRefreshError: state.status == ProfileStatus.failure,
                      onSettingsTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => const SettingsScreen(),
                          ),
                        );
                      },
                      onEditProfileTap: () =>
                          _showUnavailable(context, 'Edit Profile'),
                      onCoinsTap: () {
                        _openRewards(context, cubit);
                      },
                      onRankTap: () => _openLeaderboard(context),
                      onSeeAllAchievements: () =>
                          _showUnavailable(context, 'All achievements'),
                      onVouchersTap: () => _openVouchers(context, cubit),
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

class _ProfileLoadError extends StatelessWidget {
  const _ProfileLoadError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
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
            OutlinedButton(onPressed: onRetry, child: const Text('Try Again')),
          ],
        ),
      ),
    );
  }
}

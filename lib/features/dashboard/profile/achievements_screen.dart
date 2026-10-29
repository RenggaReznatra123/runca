import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:runca/features/dashboard/rewards/widgets/rewards_error_view.dart';
import 'package:runca/ui/color.dart';
import 'package:runca/ui/shared_view/app_page_header.dart';
import 'package:runca/ui/shared_view/empty_view.dart';
import 'package:runca/ui/shared_view/pill_chip_bar.dart';

import 'cubit/achievements_cubit.dart';
import 'cubit/achievements_state.dart';
import 'models/profile_model.dart';
import 'widgets/achievement_card.dart';

/// Semua badge milik pengguna (dibuka dari "See all" di Profile).
class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AchievementsCubit(),
      child: const _AchievementsView(),
    );
  }
}

class _AchievementsView extends StatelessWidget {
  const _AchievementsView();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AchievementsCubit>();

    return Scaffold(
      backgroundColor: AppPalette.baseWhite,
      body: SafeArea(
        child: Column(
          children: [
            const AppPageHeader(title: 'Achievements'),
            const Divider(height: 1, color: AppPalette.borderNeutral),
            const SizedBox(height: 24),
            BlocSelector<
              AchievementsCubit,
              AchievementsState,
              AchievementFilter
            >(
              selector: (state) => state.filter,
              builder: (context, filter) => PillChipBar<AchievementFilter>(
                values: AchievementFilter.values,
                selected: filter,
                labelOf: (item) => item.label,
                onChanged: cubit.selectFilter,
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: BlocBuilder<AchievementsCubit, AchievementsState>(
                builder: _buildBody,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, AchievementsState state) {
    final cubit = context.read<AchievementsCubit>();

    if (state.status == AchievementsLoadStatus.loading) {
      return const Center(
        child: CircularProgressIndicator(color: AppPalette.bgFillPrimary),
      );
    }

    if (state.status == AchievementsLoadStatus.failure) {
      return RewardsErrorView(
        title: 'Unable to load achievements',
        onRetry: cubit.loadAchievements,
      );
    }

    if (state.achievements.isEmpty) {
      return const EmptyView(message: 'No achievements found.');
    }

    return GridView.builder(
      physics: const ClampingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        mainAxisExtent: 176,
      ),
      itemCount: state.achievements.length,
      itemBuilder: (context, index) {
        final achievement = state.achievements[index];

        return AchievementCard(
          key: ValueKey(achievement.id),
          achievement: achievement,
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:runca/ui/color.dart';
import 'package:runca/ui/typography.dart';

import 'cubit/leaderboard_cubit.dart';
import 'cubit/leaderboard_state.dart';
import 'widgets/current_user_rank.dart';
import 'widgets/leaderboard_header.dart';
import 'widgets/leaderboard_period_selector.dart';
import 'widgets/ranking_item.dart';
import 'widgets/top_runners.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LeaderboardCubit(),
      child: const _LeaderboardView(),
    );
  }
}

class _LeaderboardView extends StatelessWidget {
  const _LeaderboardView();

  static const Color _textPrimary = AppPalette.textNeutralPrimary;
  static const Color _textSecondary = AppPalette.textNeutralSecondary;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPalette.baseWhite,
      body: SafeArea(
        child: BlocBuilder<LeaderboardCubit, LeaderboardState>(
          builder: (context, state) {
            final runners = state.runners;
            final currentUserIndex = runners.indexWhere(
              (runner) => runner.isCurrentUser,
            );
            final currentUser = currentUserIndex == -1
                ? null
                : runners[currentUserIndex];

            final rankings = runners
                .where((runner) => runner.rank >= 4)
                .toList(growable: false);

            return Stack(
              children: [
                Positioned.fill(
                  child: CustomScrollView(
                    key: const PageStorageKey<String>('leaderboard_scroll'),
                    primary: false,
                    physics: const ClampingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics(),
                    ),
                    slivers: [
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
                        sliver: SliverList(
                          delegate: SliverChildListDelegate([
                            const LeaderboardHeader(),
                            const SizedBox(height: 24),
                            LeaderboardPeriodSelector(
                              selectedPeriod: state.selectedPeriod,
                              onChanged: context
                                  .read<LeaderboardCubit>()
                                  .selectPeriod,
                            ),
                            const SizedBox(height: 30),
                            Text(
                              'Top Runners',
                              style:
                                  AppTypography.titleLarge(
                                    color: _textPrimary,
                                  ).copyWith(
                                    fontSize: 22,
                                    fontWeight: AppTypography.semiBold,
                                    height: 1.25,
                                  ),
                            ),
                            const SizedBox(height: 12),
                            TopRunners(runners: runners),
                            const SizedBox(height: 24),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'All Rankings',
                                    style:
                                        AppTypography.titleLarge(
                                          color: _textPrimary,
                                        ).copyWith(
                                          fontSize: 22,
                                          fontWeight: AppTypography.semiBold,
                                          height: 1.25,
                                        ),
                                  ),
                                ),
                                Text(
                                  '${runners.length + 16} runners',
                                  style: AppTypography.bodyMedium(
                                    color: _textSecondary,
                                  ).copyWith(fontSize: 14, height: 1.4),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),
                          ]),
                        ),
                      ),
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate((
                            context,
                            index,
                          ) {
                            final runner = rankings[index];

                            return Padding(
                              key: ValueKey(runner.rank),
                              padding: const EdgeInsets.only(bottom: 10),
                              child: RankingItem(runner: runner),
                            );
                          }, childCount: rankings.length),
                        ),
                      ),
                    ],
                  ),
                ),
                if (currentUser != null)
                  Positioned(
                    left: 20,
                    right: 20,
                    bottom: 12,
                    child: SafeArea(
                      top: false,
                      child: CurrentUserRank(runner: currentUser),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

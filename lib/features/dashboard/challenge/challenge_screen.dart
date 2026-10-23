import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:runca/ui/color.dart';
import 'package:runca/ui/shared_view/empty_view.dart';
import 'package:runca/ui/typography.dart';

import 'challenge_detail_screen.dart';
import 'cubit/challenge_cubit.dart';
import 'cubit/challenge_state.dart';
import 'widgets/challenge_filter.dart';
import 'widgets/challenge_header.dart';
import 'widgets/challenge_item.dart';
import 'widgets/challenge_tabs.dart';

class ChallengeScreen extends StatelessWidget {
  const ChallengeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChallengeCubit(),
      child: const _ChallengeView(),
    );
  }
}

class _ChallengeView extends StatelessWidget {
  const _ChallengeView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPalette.bg,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            BlocSelector<ChallengeCubit, ChallengeState, int>(
              selector: (state) => state.coinBalance,
              builder: (context, coinBalance) {
                return ChallengeHeader(coinBalance: coinBalance);
              },
            ),
            const SizedBox(height: 16),
            BlocSelector<ChallengeCubit, ChallengeState, ChallengeTab>(
              selector: (state) => state.selectedTab,
              builder: (context, selectedTab) {
                return ChallengeTabs(
                  selectedTab: selectedTab,
                  onChanged: context.read<ChallengeCubit>().selectTab,
                );
              },
            ),
            const SizedBox(height: 24),
            Expanded(
              child: BlocBuilder<ChallengeCubit, ChallengeState>(
                builder: (context, state) {
                  return IndexedStack(
                    index: state.selectedTab.index,
                    children: [
                      _DiscoverTab(state: state),
                      const _ComingSoonTab(label: 'Active'),
                      const _ComingSoonTab(label: 'History'),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DiscoverTab extends StatelessWidget {
  const _DiscoverTab({required this.state});

  final ChallengeState state;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ChallengeCubit>();
    final challenges = state.visibleChallenges;

    return CustomScrollView(
      key: const PageStorageKey<String>('challenge_discover_scroll'),
      physics: const ClampingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      slivers: [
        SliverToBoxAdapter(
          child: ChallengeFilterChips(
            selectedFilter: state.selectedFilter,
            onChanged: cubit.selectFilter,
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 14)),
        if (challenges.isEmpty)
          const SliverFillRemaining(
            hasScrollBody: false,
            child: EmptyView(message: 'No challenges found.'),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            sliver: SliverList.separated(
              itemCount: challenges.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final challenge = challenges[index];

                return ChallengeItem(
                  key: ValueKey(challenge.id),
                  challenge: challenge,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) =>
                            ChallengeDetailScreen(challenge: challenge),
                      ),
                    );
                  },
                );
              },
            ),
          ),
      ],
    );
  }
}

/// Sementara untuk Active dan History, karena belum ada desain di Figma.
class _ComingSoonTab extends StatelessWidget {
  const _ComingSoonTab({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        '$label coming soon.',
        style: AppTypography.bodyMedium(
          color: AppPalette.textNeutralSecondary,
        ),
      ),
    );
  }
}
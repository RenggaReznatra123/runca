import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:runca/config/app_assets.dart';
import 'package:runca/features/dashboard/rewards/widgets/rewards_error_view.dart';
import 'package:runca/ui/color.dart';

import '../challenge_detail_screen.dart';
import '../cubit/challenge_cubit.dart';
import '../cubit/challenge_state.dart';
import '../models/challenge_model.dart';
import 'challenge_empty_view.dart';
import 'challenge_filter.dart';
import 'challenge_item.dart';

/// Isi tab Active.
class ChallengeActiveTab extends StatelessWidget {
  const ChallengeActiveTab({super.key, required this.state});

  final ChallengeState state;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ChallengeCubit>();

    return _ChallengeStatusTab(
      status: state.activeStatus,
      challenges: state.activeChallenges,
      emptyIllustration: AppAssets.challengeActiveEmpty,
      emptyFallbackIcon: Icons.flag_outlined,
      emptyTitle: 'No Active Challenges Yet',
      emptyMessage:
          'Ready for a new goal? Discover a challenge and start making every '
          'run count.',
      onRetry: cubit.loadActive,
      onExplore: () => cubit.selectTab(ChallengeTab.discover),
    );
  }
}

/// Isi tab History (dengan chip filter jenis challenge).
class ChallengeHistoryTab extends StatelessWidget {
  const ChallengeHistoryTab({super.key, required this.state});

  final ChallengeState state;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ChallengeCubit>();

    return _ChallengeStatusTab(
      status: state.historyStatus,
      challenges: state.historyChallenges,
      emptyIllustration: AppAssets.challengeHistoryEmpty,
      emptyFallbackIcon: Icons.history_rounded,
      emptyTitle: 'No Challenge History Yet',
      emptyMessage:
          'Your running achievements will appear here. Complete your first '
          'challenge to start building your history.',
      onRetry: cubit.loadHistory,
      onExplore: () => cubit.selectTab(ChallengeTab.discover),
      filterChips: ChallengeFilterChips(
        selectedFilter: state.historyFilter,
        onChanged: cubit.selectHistoryFilter,
      ),
    );
  }
}

class _ChallengeStatusTab extends StatelessWidget {
  const _ChallengeStatusTab({
    required this.status,
    required this.challenges,
    required this.emptyIllustration,
    required this.emptyFallbackIcon,
    required this.emptyTitle,
    required this.emptyMessage,
    required this.onRetry,
    required this.onExplore,
    this.filterChips,
  });

  final ChallengeStatus status;
  final List<ChallengeModel> challenges;
  final String emptyIllustration;
  final IconData emptyFallbackIcon;
  final String emptyTitle;
  final String emptyMessage;
  final VoidCallback onRetry;
  final VoidCallback onExplore;
  final Widget? filterChips;

  @override
  Widget build(BuildContext context) {
    final chips = filterChips;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (chips != null) ...[chips, const SizedBox(height: 16)],
        Expanded(child: _buildBody(context)),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    if (status == ChallengeStatus.loading && challenges.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: AppPalette.bgFillPrimary),
      );
    }

    if (status == ChallengeStatus.failure) {
      return RewardsErrorView(
        title: 'Unable to load challenges',
        onRetry: onRetry,
      );
    }

    if (challenges.isEmpty) {
      return ChallengeEmptyView(
        illustrationAsset: emptyIllustration,
        fallbackIcon: emptyFallbackIcon,
        title: emptyTitle,
        message: emptyMessage,
        onExplore: onExplore,
      );
    }

    // ASUMSI: desain kartu untuk Active dan History belum ada di Figma,
    // jadi memakai kartu yang sama dengan Discover.
    return ListView.separated(
      physics: const ClampingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
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
                    ChallengeDetailScreen(challengeId: challenge.id),
              ),
            );
          },
        );
      },
    );
  }
}

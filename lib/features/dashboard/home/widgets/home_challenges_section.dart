import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:runca/features/dashboard/challenge/cubit/challenge_cubit.dart';
import 'package:runca/features/dashboard/challenge/cubit/challenge_state.dart';
import 'package:runca/features/dashboard/cubit/dashboard_cubit.dart';
import 'package:runca/features/dashboard/cubit/dashboard_state.dart';

import 'challenge_card.dart';
import 'home_section_divider.dart';
import 'home_section_header.dart';

/// Bagian "New Challenge": dua challenge pertama dan tautan "See all".
class HomeChallengesSection extends StatelessWidget {
  const HomeChallengesSection({super.key, required this.onChallengeTap});

  /// Dipanggil dengan ID challenge yang diketuk.
  final ValueChanged<String> onChallengeTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const HomeSectionDivider(),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
          child: HomeSectionHeader(
            title: 'New Challenge',
            actionLabel: 'See all',
            onActionTap: () => context.read<DashboardCubit>().selectTab(
              DashboardTab.challenge,
            ),
          ),
        ),
        BlocBuilder<ChallengeCubit, ChallengeState>(
          builder: (context, state) {
            if (state.status != ChallengeStatus.success) {
              return const SizedBox.shrink();
            }

            return Column(
              children: [
                for (final challenge in state.challenges.take(2))
                  ChallengeCard(
                    challenge: challenge,
                    onTap: () => onChallengeTap(challenge.id),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}

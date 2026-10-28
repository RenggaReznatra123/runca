import 'package:flutter/material.dart';
import 'package:runca/features/dashboard/challenge/models/challenge_model.dart';
import 'package:runca/features/dashboard/challenge/widgets/challenge_info_card.dart';
import 'package:runca/features/dashboard/challenge/widgets/challenge_requirement_list.dart';
import 'package:runca/features/dashboard/challenge/widgets/challenge_reward_row.dart';
import 'package:runca/ui/color.dart';
import 'package:runca/ui/typography.dart';
import 'package:runca/utility/format_utils.dart';

class ChallengeDetailSheet extends StatelessWidget {
  const ChallengeDetailSheet({super.key, required this.challenge});

  final ChallengeDetail challenge;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
      decoration: const BoxDecoration(
        color: AppPalette.baseWhite,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle('About This Challenge'),
          const SizedBox(height: 8),
          Text(
            challenge.about,
            style: AppTypography.bodyMedium(
              color: AppPalette.textNeutralSecondary,
            ).copyWith(height: 24 / 14),
          ),
          const SizedBox(height: 20),
          ChallengeInfoCard(
            dateRange: AppFormat.dateRange(
              challenge.startDate,
              challenge.endDate,
            ),
            target: AppFormat.targetKm(challenge.targetKm),
          ),
          const SizedBox(height: 20),
          const _SectionTitle('Requirements'),
          const SizedBox(height: 10),
          ChallengeRequirementList(items: challenge.requirements),
          const SizedBox(height: 18),
          const _SectionTitle('Rewards'),
          const SizedBox(height: 16),
          ChallengeRewardRow(amount: challenge.rewardCoins),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTypography.titleMedium(color: AppPalette.textNeutralPrimary),
    );
  }
}

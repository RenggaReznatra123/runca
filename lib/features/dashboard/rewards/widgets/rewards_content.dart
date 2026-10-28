import 'package:flutter/material.dart';
import 'package:runca/features/dashboard/rewards/cubit/rewards_state.dart';
import 'package:runca/features/dashboard/rewards/models/reward_model.dart';
import 'package:runca/ui/color.dart';
import 'package:runca/ui/shared_view/empty_view.dart';

import 'reward_balance_card.dart';
import 'reward_card.dart';

class RewardsContent extends StatelessWidget {
  const RewardsContent({
    required this.state,
    required this.onHistoryTap,
    required this.onHowToEarnTap,
    required this.onFilterChanged,
    required this.onRewardTap,
    super.key,
  });

  final RewardsState state;
  final VoidCallback onHistoryTap;
  final VoidCallback onHowToEarnTap;
  final ValueChanged<RewardFilter> onFilterChanged;
  final ValueChanged<RewardModel> onRewardTap;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const ClampingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
            child: RewardBalanceCard(
              balance: state.coinBalance,
              onHistoryTap: onHistoryTap,
              onHowToEarnTap: onHowToEarnTap,
            ),
          ),
        ),
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 36, 20, 18),
            child: Text(
              'Available Rewards',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppPalette.textNeutralPrimary,
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: SizedBox(
            height: 42,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              scrollDirection: Axis.horizontal,
              itemCount: RewardFilter.values.length,
              separatorBuilder: (_, _) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                final filter = RewardFilter.values[index];
                final selected = state.selectedFilter == filter;

                return ChoiceChip(
                  label: Text(filter.label),
                  selected: selected,
                  showCheckmark: false,
                  onSelected: (_) => onFilterChanged(filter),
                  labelStyle: TextStyle(
                    fontSize: 14,
                    color: selected
                        ? AppPalette.textWhitePrimary
                        : AppPalette.textNeutralPrimary,
                  ),
                  backgroundColor: AppPalette.baseWhite,
                  selectedColor: AppPalette.bgFillPrimary,
                  side: BorderSide(
                    color: selected
                        ? AppPalette.bgFillPrimary
                        : AppPalette.borderNeutral,
                  ),
                  shape: const StadiumBorder(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                );
              },
            ),
          ),
        ),
        if (state.rewards.isEmpty)
          const SliverFillRemaining(
            hasScrollBody: false,
            child: EmptyView(message: 'No rewards found.'),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 14,
                mainAxisSpacing: 10,
                mainAxisExtent: 290,
              ),
              delegate: SliverChildBuilderDelegate((context, index) {
                final reward = state.rewards[index];

                return RewardCard(
                  key: ValueKey(reward.id),
                  reward: reward,
                  onTap: () => onRewardTap(reward),
                );
              }, childCount: state.rewards.length),
            ),
          ),
      ],
    );
  }
}

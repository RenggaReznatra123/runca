import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:runca/ui/color.dart';
import 'package:runca/ui/shared_view/empty_view.dart';

import 'cubit/rewards_cubit.dart';
import 'cubit/rewards_state.dart';
import 'models/reward_model.dart';
import 'voucher_detail_screen.dart';
import 'widgets/reward_balance_card.dart';
import 'widgets/reward_card.dart';
import 'widgets/rewards_error_view.dart';

class RewardsScreen extends StatelessWidget {
  const RewardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RewardsCubit(),
      child: const _RewardsView(),
    );
  }
}

class _RewardsView extends StatelessWidget {
  const _RewardsView();

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

  Future<void> _openVoucherDetail(
    BuildContext context,
    RewardModel reward,
  ) async {
    final cubit = context.read<RewardsCubit>();

    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => VoucherDetailScreen(rewardId: reward.id),
      ),
    );

    // Saldo dan stok bisa berubah setelah redeem.
    cubit.refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPalette.bg,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: SizedBox(
                height: 44,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const Text(
                      'Rewards',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: AppPalette.textNeutralPrimary,
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        onPressed: () => Navigator.of(context).maybePop(),
                        icon: const Icon(Icons.arrow_back_ios_new_rounded),
                        iconSize: 20,
                        color: AppPalette.textNeutralPrimary,
                        padding: EdgeInsets.zero,
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        onPressed: () =>
                            _showUnavailable(context, 'My Vouchers'),
                        icon: const Icon(Icons.confirmation_number_outlined),
                        iconSize: 25,
                        color: AppPalette.textNeutralPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: BlocBuilder<RewardsCubit, RewardsState>(
                builder: (context, state) => _buildBody(context, state),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, RewardsState state) {
    final cubit = context.read<RewardsCubit>();

    if (state.status == RewardsStatus.loading) {
      return const Center(
        child: CircularProgressIndicator(color: AppPalette.bgFillPrimary),
      );
    }

    if (state.status == RewardsStatus.failure) {
      return RewardsErrorView(
        title: 'Unable to load rewards',
        onRetry: cubit.loadRewards,
      );
    }

    return CustomScrollView(
      physics: const ClampingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
            child: RewardBalanceCard(
              balance: state.coinBalance,
              onHistoryTap: () => _showUnavailable(context, 'PlaCoins History'),
              onHowToEarnTap: () => _showUnavailable(context, 'How to Earn'),
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
                  onSelected: (_) => cubit.selectFilter(filter),
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
                  onTap: () => _openVoucherDetail(context, reward),
                );
              }, childCount: state.rewards.length),
            ),
          ),
      ],
    );
  }
}
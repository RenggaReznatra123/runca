import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:runca/ui/color.dart';

import 'cubit/rewards_cubit.dart';
import 'cubit/rewards_state.dart';
import 'how_to_earn_screen.dart';
import 'my_vouchers_screen.dart';
import 'models/reward_model.dart';
import 'placoin_history_screen.dart';
import 'voucher_detail_screen.dart';
import 'widgets/rewards_error_view.dart';
import 'widgets/rewards_content.dart';

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
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => MyVouchersScreen(
                                // Dari Rewards: cukup kembali ke Rewards.
                                onExploreRewards: () =>
                                    Navigator.of(context).maybePop(),
                              ),
                            ),
                          );
                        },
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
                builder: (context, state) {
                  final cubit = context.read<RewardsCubit>();

                  if (state.status == RewardsStatus.loading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppPalette.bgFillPrimary,
                      ),
                    );
                  }

                  if (state.status == RewardsStatus.failure) {
                    return RewardsErrorView(
                      title: 'Unable to load rewards',
                      onRetry: cubit.loadRewards,
                    );
                  }

                  return RewardsContent(
                    state: state,
                    onHistoryTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => const PlaCoinHistoryScreen(),
                        ),
                      );
                    },
                    onHowToEarnTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => const HowToEarnScreen(),
                        ),
                      );
                    },
                    onFilterChanged: cubit.selectFilter,
                    onRewardTap: (reward) {
                      _openVoucherDetail(context, reward);
                    },
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

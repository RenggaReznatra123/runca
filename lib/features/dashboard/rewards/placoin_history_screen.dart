import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:runca/ui/color.dart';
import 'package:runca/ui/typography.dart';

import 'cubit/placoin_history_cubit.dart';
import 'cubit/placoin_history_state.dart';
import 'how_to_earn_screen.dart';
import 'models/placoin_transaction_model.dart';
import 'widgets/placoin_history_empty_view.dart';
import 'widgets/placoin_history_group.dart';
import 'widgets/placoin_history_tabs.dart';
import 'widgets/rewards_error_view.dart';

/// Riwayat transaksi PlaCoins (dibuka dari kartu saldo di Rewards).
class PlaCoinHistoryScreen extends StatelessWidget {
  const PlaCoinHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PlaCoinHistoryCubit(),
      child: const _PlaCoinHistoryView(),
    );
  }
}

class _PlaCoinHistoryView extends StatelessWidget {
  const _PlaCoinHistoryView();

  /// Kelompokkan transaksi per hari. Urutan mengikuti urutan dari repository.
  Map<DateTime, List<PlaCoinTransaction>> _groupByDay(
    List<PlaCoinTransaction> items,
  ) {
    final groups = <DateTime, List<PlaCoinTransaction>>{};

    for (final item in items) {
      final day = DateTime(
        item.createdAt.year,
        item.createdAt.month,
        item.createdAt.day,
      );
      groups.putIfAbsent(day, () => []).add(item);
    }

    return groups;
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<PlaCoinHistoryCubit>();

    return Scaffold(
      backgroundColor: AppPalette.baseWhite,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 56,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).maybePop(),
                      icon: const Icon(Icons.arrow_back_ios_new_rounded),
                      iconSize: 20,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 28,
                        minHeight: 44,
                      ),
                      color: AppPalette.textNeutralPrimary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'PlaCoins History',
                      style: AppTypography.titleMedium(
                        color: AppPalette.textNeutralPrimary,
                      ).copyWith(fontWeight: AppTypography.medium),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 22),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child:
                  BlocSelector<
                    PlaCoinHistoryCubit,
                    PlaCoinHistoryState,
                    PlaCoinHistoryFilter
                  >(
                    selector: (state) => state.filter,
                    builder: (context, filter) => PlaCoinHistoryTabs(
                      selected: filter,
                      onChanged: cubit.selectFilter,
                    ),
                  ),
            ),
            Expanded(
              child: BlocBuilder<PlaCoinHistoryCubit, PlaCoinHistoryState>(
                builder: (context, state) => _buildBody(context, state),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, PlaCoinHistoryState state) {
    final cubit = context.read<PlaCoinHistoryCubit>();

    if (state.status == PlaCoinHistoryStatus.loading) {
      return const Center(
        child: CircularProgressIndicator(color: AppPalette.bgFillPrimary),
      );
    }

    if (state.status == PlaCoinHistoryStatus.failure) {
      return RewardsErrorView(
        title: 'Unable to load history',
        onRetry: cubit.loadHistory,
      );
    }

    if (state.transactions.isEmpty) {
      return PlaCoinHistoryEmptyView(
        onHowToEarn: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(builder: (_) => const HowToEarnScreen()),
          );
        },
      );
    }

    final groups = _groupByDay(state.transactions).entries.toList();

    return ListView.builder(
      physics: const ClampingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
      itemCount: groups.length,
      itemBuilder: (context, index) {
        final group = groups[index];

        return PlaCoinHistoryGroup(
          key: ValueKey(group.key),
          date: group.key,
          transactions: group.value,
        );
      },
    );
  }
}

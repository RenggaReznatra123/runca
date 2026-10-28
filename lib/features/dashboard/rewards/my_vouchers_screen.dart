import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:runca/ui/color.dart';
import 'package:runca/ui/typography.dart';

import 'cubit/my_vouchers_cubit.dart';
import 'cubit/my_vouchers_state.dart';
import 'models/my_voucher_model.dart';
import 'my_voucher_detail_screen.dart';
import 'widgets/my_voucher_card.dart';
import 'widgets/my_vouchers_empty_view.dart';
import 'widgets/rewards_filter_tabs.dart';
import 'widgets/rewards_error_view.dart';
import 'widgets/voucher_cashier_banner.dart';

/// Daftar semua voucher milik pengguna (tab Active / Used / Expired).
class MyVouchersScreen extends StatelessWidget {
  const MyVouchersScreen({super.key, required this.onExploreRewards});

  /// Aksi tombol Explore Rewards. Pemanggil yang menentukan tujuannya.
  final VoidCallback onExploreRewards;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MyVouchersCubit(),
      child: _MyVouchersView(onExploreRewards: onExploreRewards),
    );
  }
}

class _MyVouchersView extends StatelessWidget {
  const _MyVouchersView({required this.onExploreRewards});

  final VoidCallback onExploreRewards;

  void _openDetail(BuildContext context, MyVoucherSummary voucher) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => MyVoucherDetailScreen(voucherId: voucher.id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<MyVouchersCubit>();

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
                      'My Voucher',
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
                  BlocSelector<MyVouchersCubit, MyVouchersState, VoucherStatus>(
                    selector: (state) => state.filter,
                    builder: (context, filter) => RewardsFilterTabs(
                      options: VoucherStatus.values,
                      selected: filter,
                      labelBuilder: (status) => status.label,
                      onChanged: cubit.selectFilter,
                    ),
                  ),
            ),
            Expanded(
              child: BlocBuilder<MyVouchersCubit, MyVouchersState>(
                builder: (context, state) => _buildBody(context, state),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, MyVouchersState state) {
    final cubit = context.read<MyVouchersCubit>();

    if (state.status == MyVouchersLoadStatus.loading) {
      return const Center(
        child: CircularProgressIndicator(color: AppPalette.bgFillPrimary),
      );
    }

    if (state.status == MyVouchersLoadStatus.failure) {
      return RewardsErrorView(
        title: 'Unable to load vouchers',
        onRetry: cubit.loadVouchers,
      );
    }

    if (state.vouchers.isEmpty) {
      return MyVouchersEmptyView(
        status: state.filter,
        onExploreRewards: onExploreRewards,
      );
    }

    // Banner hanya di tab Active, menjadi item terakhir daftar.
    final showBanner = state.filter == VoucherStatus.active;
    final itemCount = state.vouchers.length + (showBanner ? 1 : 0);

    return ListView.builder(
      physics: const ClampingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        if (index >= state.vouchers.length) {
          return const Padding(
            padding: EdgeInsets.only(top: 8),
            child: VoucherCashierBanner(),
          );
        }

        final voucher = state.vouchers[index];

        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: MyVoucherCard(
            key: ValueKey(voucher.id),
            voucher: voucher,
            onTap: () => _openDetail(context, voucher),
          ),
        );
      },
    );
  }
}

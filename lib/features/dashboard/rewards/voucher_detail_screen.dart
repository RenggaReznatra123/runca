import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:runca/ui/color.dart';

import 'cubit/voucher_detail_cubit.dart';
import 'cubit/voucher_detail_state.dart';
import 'voucher_success_screen.dart';
import 'widgets/redeem_confirmation_dialog.dart';
import 'widgets/rewards_error_view.dart';
import 'widgets/voucher_detail_content.dart';
import 'widgets/voucher_redeem_bar.dart';

class VoucherDetailScreen extends StatelessWidget {
  const VoucherDetailScreen({super.key, required this.rewardId});

  final String rewardId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => VoucherDetailCubit(rewardId: rewardId),
      child: const _VoucherDetailView(),
    );
  }
}

class _VoucherDetailView extends StatelessWidget {
  const _VoucherDetailView();

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
  }

  Future<void> _confirmRedeem(
    BuildContext context,
    VoucherDetailState state,
  ) async {
    final detail = state.detail;
    if (detail == null) return;

    final cubit = context.read<VoucherDetailCubit>();

    final confirmed = await RedeemConfirmationDialog.show(
      context,
      rewardTitle: detail.title,
      brandName: detail.brandName,
      price: detail.price,
      balance: state.coinBalance,
    );

    if (confirmed) cubit.redeem();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<VoucherDetailCubit, VoucherDetailState>(
      listenWhen: (previous, current) =>
          previous.redeemStatus != current.redeemStatus,
      listener: (context, state) {
        switch (state.redeemStatus) {
          case VoucherRedeemStatus.success:
            {
              final detail = state.detail;
              if (detail == null) return;

              // Diganti (bukan ditumpuk) supaya tombol back dari halaman
              // sukses kembali ke daftar Rewards.
              Navigator.of(context).pushReplacement(
                MaterialPageRoute<void>(
                  builder: (_) => VoucherSuccessScreen(detail: detail),
                ),
              );
            }
          case VoucherRedeemStatus.failure:
            {
              _showMessage(
                context,
                'Unable to redeem this voucher. Please try again.',
              );
              context.read<VoucherDetailCubit>().clearRedeemStatus();
            }
          case VoucherRedeemStatus.idle:
          case VoucherRedeemStatus.redeeming:
            break;
        }
      },
      child: Scaffold(
        backgroundColor: AppPalette.baseWhite,
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                child: SizedBox(
                  height: 44,
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
                      const SizedBox(width: 12),
                      const Text(
                        'Voucher Detail',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: AppPalette.textNeutralPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: BlocBuilder<VoucherDetailCubit, VoucherDetailState>(
                  builder: (context, state) {
                    if (state.loadStatus == VoucherLoadStatus.loading) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppPalette.bgFillPrimary,
                        ),
                      );
                    }

                    final detail = state.detail;

                    if (state.loadStatus == VoucherLoadStatus.failure ||
                        detail == null) {
                      return RewardsErrorView(
                        title: 'Unable to load voucher',
                        onRetry: context.read<VoucherDetailCubit>().loadDetail,
                      );
                    }

                    return VoucherDetailContent(detail: detail);
                  },
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar:
            BlocBuilder<VoucherDetailCubit, VoucherDetailState>(
              builder: (context, state) {
                final detail = state.detail;

                if (state.loadStatus != VoucherLoadStatus.success ||
                    detail == null) {
                  return const SizedBox.shrink();
                }

                return VoucherRedeemBar(
                  price: detail.price,
                  balance: state.coinBalance,
                  isRedeeming:
                      state.redeemStatus == VoucherRedeemStatus.redeeming,
                  onRedeem: () => _confirmRedeem(context, state),
                );
              },
            ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:runca/ui/color.dart';
import 'package:runca/ui/typography.dart';

import 'cubit/my_voucher_detail_cubit.dart';
import 'cubit/my_voucher_detail_state.dart';
import 'widgets/rewards_error_view.dart';
import 'widgets/voucher_outlet_card.dart';
import 'widgets/voucher_terms_card.dart';
import 'widgets/voucher_ticket_card.dart';

/// Detail voucher milik pengguna (QR code, kode, outlet, syarat).
class MyVoucherDetailScreen extends StatelessWidget {
  const MyVoucherDetailScreen({super.key, required this.voucherId});

  final String voucherId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MyVoucherDetailCubit(voucherId: voucherId),
      child: const _MyVoucherDetailView(),
    );
  }
}

class _MyVoucherDetailView extends StatelessWidget {
  const _MyVoucherDetailView();

  Future<void> _copyCode(BuildContext context, String code) async {
    await Clipboard.setData(ClipboardData(text: code));

    if (!context.mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
          backgroundColor: AppPalette.transparent,
          elevation: 0,
          padding: EdgeInsets.zero,
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 16),
          content: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: AppPalette.bgSurfaceSuccess,
              border: Border.all(color: AppPalette.borderSuccess),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.check_rounded,
                  size: 18,
                  color: AppPalette.iconSuccess,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Voucher code copied',
                    style: AppTypography.bodyMedium(
                      color: AppPalette.textSuccess,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VoucherTicketCard.pageColor,
      body: Column(
        children: [
          Container(
            color: AppPalette.bg,
            child: SafeArea(
              bottom: false,
              child: SizedBox(
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
                        'Voucher Detail',
                        style: AppTypography.titleMedium(
                          color: AppPalette.textNeutralPrimary,
                        ).copyWith(fontWeight: AppTypography.medium),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: SafeArea(
              top: false,
              child: BlocBuilder<MyVoucherDetailCubit, MyVoucherDetailState>(
                builder: _buildBody,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context, MyVoucherDetailState state) {
    if (state.status == MyVoucherDetailStatus.loading) {
      return const Center(
        child: CircularProgressIndicator(color: AppPalette.bgFillPrimary),
      );
    }

    final voucher = state.voucher;

    if (state.status == MyVoucherDetailStatus.failure || voucher == null) {
      return RewardsErrorView(
        title: 'Unable to load voucher',
        onRetry: context.read<MyVoucherDetailCubit>().loadVoucher,
      );
    }

    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      child: Column(
        children: [
          VoucherTicketCard(
            voucher: voucher,
            onCopyCode: () => _copyCode(context, voucher.code),
          ),
          const SizedBox(height: 8),
          VoucherOutletCard(outlet: voucher.outlet),
          if (voucher.terms.isNotEmpty) ...[
            const SizedBox(height: 8),
            VoucherTermsCard(terms: voucher.terms),
          ],
        ],
      ),
    );
  }
}

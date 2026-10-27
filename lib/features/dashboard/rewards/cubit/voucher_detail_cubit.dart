import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:runca/config/service_locator.dart';
import 'package:runca/repository/rewards_repository.dart';
import 'package:runca/utility/resource/data_state.dart';

import '../models/reward_model.dart';
import 'voucher_detail_state.dart';

class VoucherDetailCubit extends Cubit<VoucherDetailState> {
  VoucherDetailCubit({required String rewardId, RewardsRepository? repository})
    : _rewardId = rewardId,
      _repository = repository ?? serviceLocator.get<RewardsRepository>(),
      super(const VoucherDetailState()) {
    loadDetail();
  }

  final String _rewardId;
  final RewardsRepository _repository;

  Future<void> loadDetail() async {
    emit(state.copyWith(loadStatus: VoucherLoadStatus.loading));

    final result = await _repository.getRewardDetail(_rewardId);

    if (isClosed) return;

    if (result is DataStateSuccess<RewardDetailData>) {
      final data = result.data;

      if (data != null) {
        emit(
          state.copyWith(
            loadStatus: VoucherLoadStatus.success,
            detail: data.detail,
            coinBalance: data.coinBalance,
          ),
        );
        return;
      }
    }

    emit(state.copyWith(loadStatus: VoucherLoadStatus.failure));
  }

  Future<void> redeem() async {
    if (state.redeemStatus == VoucherRedeemStatus.redeeming) return;
    if (state.detail == null || !state.hasEnoughCoins) return;

    emit(state.copyWith(redeemStatus: VoucherRedeemStatus.redeeming));

    final result = await _repository.redeemReward(_rewardId);

    if (isClosed) return;

    if (result is DataStateSuccess<RedeemResult>) {
      final data = result.data;

      if (data != null) {
        emit(
          state.copyWith(
            redeemStatus: VoucherRedeemStatus.success,
            coinBalance: data.remainingBalance,
            voucherId: data.voucherId,
          ),
        );
        return;
      }
    }

    emit(state.copyWith(redeemStatus: VoucherRedeemStatus.failure));
  }

  void clearRedeemStatus() {
    emit(state.copyWith(redeemStatus: VoucherRedeemStatus.idle));
  }
}

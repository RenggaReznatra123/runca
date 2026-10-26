import '../models/reward_model.dart';

enum VoucherLoadStatus { loading, success, failure }

enum VoucherRedeemStatus { idle, redeeming, success, failure }

class VoucherDetailState {
  const VoucherDetailState({
    this.loadStatus = VoucherLoadStatus.loading,
    this.redeemStatus = VoucherRedeemStatus.idle,
    this.detail,
    this.coinBalance = 0,
  });

  final VoucherLoadStatus loadStatus;
  final VoucherRedeemStatus redeemStatus;
  final RewardDetail? detail;
  final int coinBalance;

  bool get hasEnoughCoins {
    final current = detail;
    return current != null && coinBalance >= current.price;
  }

  VoucherDetailState copyWith({
    VoucherLoadStatus? loadStatus,
    VoucherRedeemStatus? redeemStatus,
    RewardDetail? detail,
    int? coinBalance,
  }) {
    return VoucherDetailState(
      loadStatus: loadStatus ?? this.loadStatus,
      redeemStatus: redeemStatus ?? this.redeemStatus,
      detail: detail ?? this.detail,
      coinBalance: coinBalance ?? this.coinBalance,
    );
  }
}

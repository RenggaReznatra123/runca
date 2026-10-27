import '../models/reward_model.dart';

enum VoucherLoadStatus { loading, success, failure }

enum VoucherRedeemStatus { idle, redeeming, success, failure }

class VoucherDetailState {
  const VoucherDetailState({
    this.loadStatus = VoucherLoadStatus.loading,
    this.redeemStatus = VoucherRedeemStatus.idle,
    this.detail,
    this.coinBalance = 0,
    this.voucherId,
  });

  final VoucherLoadStatus loadStatus;
  final VoucherRedeemStatus redeemStatus;
  final RewardDetail? detail;
  final int coinBalance;

  /// ID voucher hasil redeem. Null sebelum redeem berhasil.
  final String? voucherId;

  bool get hasEnoughCoins {
    final current = detail;
    return current != null && coinBalance >= current.price;
  }

  VoucherDetailState copyWith({
    VoucherLoadStatus? loadStatus,
    VoucherRedeemStatus? redeemStatus,
    RewardDetail? detail,
    int? coinBalance,
    String? voucherId,
  }) {
    return VoucherDetailState(
      loadStatus: loadStatus ?? this.loadStatus,
      redeemStatus: redeemStatus ?? this.redeemStatus,
      detail: detail ?? this.detail,
      coinBalance: coinBalance ?? this.coinBalance,
      voucherId: voucherId ?? this.voucherId,
    );
  }
}

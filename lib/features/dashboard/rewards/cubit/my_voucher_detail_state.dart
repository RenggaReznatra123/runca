import '../models/reward_model.dart';

enum MyVoucherDetailStatus { loading, success, failure }

class MyVoucherDetailState {
  const MyVoucherDetailState({
    this.status = MyVoucherDetailStatus.loading,
    this.voucher,
    this.hasRefreshError = false,
  });

  final MyVoucherDetailStatus status;
  final RedeemedVoucher? voucher;
  final bool hasRefreshError;

  MyVoucherDetailState copyWith({
    MyVoucherDetailStatus? status,
    RedeemedVoucher? voucher,
    bool? hasRefreshError,
  }) {
    return MyVoucherDetailState(
      status: status ?? this.status,
      voucher: voucher ?? this.voucher,
      hasRefreshError: hasRefreshError ?? this.hasRefreshError,
    );
  }
}

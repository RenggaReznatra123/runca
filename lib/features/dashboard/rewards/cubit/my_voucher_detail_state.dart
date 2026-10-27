import '../models/reward_model.dart';

enum MyVoucherDetailStatus { loading, success, failure }

class MyVoucherDetailState {
  const MyVoucherDetailState({
    this.status = MyVoucherDetailStatus.loading,
    this.voucher,
  });

  final MyVoucherDetailStatus status;
  final RedeemedVoucher? voucher;

  MyVoucherDetailState copyWith({
    MyVoucherDetailStatus? status,
    RedeemedVoucher? voucher,
  }) {
    return MyVoucherDetailState(
      status: status ?? this.status,
      voucher: voucher ?? this.voucher,
    );
  }
}

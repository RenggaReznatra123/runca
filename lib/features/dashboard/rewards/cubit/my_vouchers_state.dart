import '../models/my_voucher_model.dart';

enum MyVouchersLoadStatus { loading, success, failure }

class MyVouchersState {
  const MyVouchersState({
    this.status = MyVouchersLoadStatus.loading,
    this.filter = VoucherStatus.active,
    this.vouchers = const [],
  });

  final MyVouchersLoadStatus status;
  final VoucherStatus filter;

  /// Hasil dari repository, sudah terfilter.
  final List<MyVoucherSummary> vouchers;

  MyVouchersState copyWith({
    MyVouchersLoadStatus? status,
    VoucherStatus? filter,
    List<MyVoucherSummary>? vouchers,
  }) {
    return MyVouchersState(
      status: status ?? this.status,
      filter: filter ?? this.filter,
      vouchers: vouchers ?? this.vouchers,
    );
  }
}

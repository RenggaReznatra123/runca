import '../models/my_voucher_model.dart';

enum MyVouchersLoadStatus { loading, success, failure }

class MyVouchersState {
  const MyVouchersState({
    this.status = MyVouchersLoadStatus.loading,
    this.filter = VoucherStatus.active,
    this.vouchers = const [],
    this.hasRefreshError = false,
  });

  final MyVouchersLoadStatus status;
  final VoucherStatus filter;
  final bool hasRefreshError;

  /// Hasil dari repository, sudah terfilter.
  final List<MyVoucherSummary> vouchers;

  MyVouchersState copyWith({
    MyVouchersLoadStatus? status,
    VoucherStatus? filter,
    List<MyVoucherSummary>? vouchers,
    bool? hasRefreshError,
  }) {
    return MyVouchersState(
      status: status ?? this.status,
      filter: filter ?? this.filter,
      vouchers: vouchers ?? this.vouchers,
      hasRefreshError: hasRefreshError ?? this.hasRefreshError,
    );
  }
}

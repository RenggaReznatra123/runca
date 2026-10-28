import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:runca/config/service_locator.dart';
import 'package:runca/repository/rewards_repository.dart';
import 'package:runca/utility/resource/data_state.dart';

import '../models/my_voucher_model.dart';
import 'my_vouchers_state.dart';

class MyVouchersCubit extends Cubit<MyVouchersState> {
  MyVouchersCubit({RewardsRepository? repository})
    : _repository = repository ?? serviceLocator.get<RewardsRepository>(),
      super(const MyVouchersState()) {
    loadVouchers();
  }

  final RewardsRepository _repository;
  int _requestId = 0;

  /// Muat awal dan Try Again: layar menampilkan loading.
  Future<void> loadVouchers() async {
    emit(state.copyWith(status: MyVouchersLoadStatus.loading));
    await _fetch();
  }

  /// Ganti tab: daftar lama tetap tampil sampai hasil baru datang.
  Future<void> selectFilter(VoucherStatus filter) async {
    if (filter == state.filter) return;

    emit(state.copyWith(filter: filter));
    await _fetch();
  }

  Future<void> _fetch() async {
    final requestId = ++_requestId;

    final result = await _repository.getMyVouchers(status: state.filter);

    if (isClosed || requestId != _requestId) return;

    if (result is DataStateSuccess<List<MyVoucherSummary>>) {
      final data = result.data;

      if (data != null) {
        emit(
          state.copyWith(status: MyVouchersLoadStatus.success, vouchers: data),
        );
        return;
      }
    }

    emit(state.copyWith(status: MyVouchersLoadStatus.failure));
  }
}

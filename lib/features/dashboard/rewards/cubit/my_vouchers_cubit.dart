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
    emit(
      state.copyWith(
        status: MyVouchersLoadStatus.loading,
        hasRefreshError: false,
      ),
    );
    await _fetch();
  }

  Future<void> refresh() => _fetch(isRefresh: true);

  void clearRefreshError() {
    if (state.hasRefreshError) {
      emit(state.copyWith(hasRefreshError: false));
    }
  }

  /// Ganti tab: daftar lama tetap tampil sampai hasil baru datang.
  Future<void> selectFilter(VoucherStatus filter) async {
    if (filter == state.filter) return;

    emit(state.copyWith(filter: filter));
    await _fetch();
  }

  Future<void> _fetch({bool isRefresh = false}) async {
    final requestId = ++_requestId;

    final result = await _repository.getMyVouchers(status: state.filter);

    if (isClosed || requestId != _requestId) return;

    if (result is DataStateSuccess<List<MyVoucherSummary>>) {
      final data = result.data;

      if (data != null) {
        emit(
          state.copyWith(
            status: MyVouchersLoadStatus.success,
            vouchers: data,
            hasRefreshError: false,
          ),
        );
        return;
      }
    }

    if (isRefresh) {
      emit(state.copyWith(hasRefreshError: true));
    } else {
      emit(
        state.copyWith(
          status: MyVouchersLoadStatus.failure,
          hasRefreshError: false,
        ),
      );
    }
  }
}

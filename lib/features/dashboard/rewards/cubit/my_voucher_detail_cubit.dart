import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:runca/config/service_locator.dart';
import 'package:runca/repository/rewards_repository.dart';
import 'package:runca/utility/resource/data_state.dart';

import '../models/reward_model.dart';
import 'my_voucher_detail_state.dart';

class MyVoucherDetailCubit extends Cubit<MyVoucherDetailState> {
  MyVoucherDetailCubit({
    required this._voucherId,
    RewardsRepository? repository,
  }) : _repository = repository ?? serviceLocator.get<RewardsRepository>(),
       super(const MyVoucherDetailState()) {
    loadVoucher();
  }

  final String _voucherId;
  final RewardsRepository _repository;
  int _requestId = 0;

  Future<void> loadVoucher() => _fetch(showLoading: true);

  Future<void> refresh() => _fetch(showLoading: false);

  void clearRefreshError() {
    if (state.hasRefreshError) {
      emit(state.copyWith(hasRefreshError: false));
    }
  }

  Future<void> _fetch({required bool showLoading}) async {
    final requestId = ++_requestId;

    if (showLoading) {
      emit(
        state.copyWith(
          status: MyVoucherDetailStatus.loading,
          hasRefreshError: false,
        ),
      );
    }

    final result = await _repository.getVoucher(_voucherId);

    if (isClosed || requestId != _requestId) return;

    if (result is DataStateSuccess<RedeemedVoucher>) {
      final data = result.data;

      if (data != null) {
        emit(
          state.copyWith(
            status: MyVoucherDetailStatus.success,
            voucher: data,
            hasRefreshError: false,
          ),
        );
        return;
      }
    }

    if (showLoading) {
      emit(
        state.copyWith(
          status: MyVoucherDetailStatus.failure,
          hasRefreshError: false,
        ),
      );
    } else {
      emit(state.copyWith(hasRefreshError: true));
    }
  }
}

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

  Future<void> loadVoucher() async {
    final requestId = ++_requestId;

    emit(state.copyWith(status: MyVoucherDetailStatus.loading));

    final result = await _repository.getVoucher(_voucherId);

    if (isClosed || requestId != _requestId) return;

    if (result is DataStateSuccess<RedeemedVoucher>) {
      final data = result.data;

      if (data != null) {
        emit(
          state.copyWith(status: MyVoucherDetailStatus.success, voucher: data),
        );
        return;
      }
    }

    emit(state.copyWith(status: MyVoucherDetailStatus.failure));
  }
}

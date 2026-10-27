import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:runca/config/service_locator.dart';
import 'package:runca/repository/rewards_repository.dart';
import 'package:runca/utility/resource/data_state.dart';

import '../models/reward_model.dart';
import 'how_to_earn_state.dart';

class HowToEarnCubit extends Cubit<HowToEarnState> {
  HowToEarnCubit({RewardsRepository? repository})
    : _repository = repository ?? serviceLocator.get<RewardsRepository>(),
      super(const HowToEarnState()) {
    loadMethods();
  }

  final RewardsRepository _repository;
  int _requestId = 0;

  Future<void> loadMethods() async {
    final requestId = ++_requestId;

    emit(state.copyWith(status: HowToEarnStatus.loading));

    final result = await _repository.getEarnMethods();

    if (isClosed || requestId != _requestId) return;

    if (result is DataStateSuccess<List<EarnMethod>>) {
      final data = result.data;

      if (data != null) {
        emit(state.copyWith(status: HowToEarnStatus.success, methods: data));
        return;
      }
    }

    emit(state.copyWith(status: HowToEarnStatus.failure));
  }
}

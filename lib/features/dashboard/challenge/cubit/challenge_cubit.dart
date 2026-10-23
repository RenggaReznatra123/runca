import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:runca/config/service_locator.dart';
import 'package:runca/features/dashboard/challenge/models/challenge_model.dart';
import 'package:runca/repository/challenge_repository.dart';
import 'package:runca/utility/resource/data_state.dart';

import 'challenge_state.dart';

class ChallengeCubit extends Cubit<ChallengeState> {
  ChallengeCubit({ChallengeRepository? repository})
    : _repository = repository ?? serviceLocator.get<ChallengeRepository>(),
      super(const ChallengeState()) {
    loadChallenges();
  }

  final ChallengeRepository _repository;
  int _requestId = 0;

  Future<void> loadChallenges() => _fetch(showLoading: true, withBalance: true);

  void selectTab(ChallengeTab tab) {
    if (tab == state.selectedTab) return;
    emit(state.copyWith(selectedTab: tab));
  }

  void selectFilter(ChallengeFilter filter) {
    if (filter == state.selectedFilter) return;
    emit(state.copyWith(selectedFilter: filter));
    _fetch(showLoading: false);
  }

  Future<void> _fetch({
    required bool showLoading,
    bool withBalance = false,
  }) async {
    final requestId = ++_requestId;
    if (showLoading) emit(state.copyWith(status: ChallengeStatus.loading));

    if (withBalance) {
      final (challengeResult, balanceResult) = await (
        _repository.getChallenges(type: state.selectedFilter.type),
        _repository.getCoinBalance(),
      ).wait;
      if (isClosed || requestId != _requestId) return;

      if (challengeResult is DataStateSuccess<List<ChallengeModel>> &&
          balanceResult is DataStateSuccess<int>) {
        emit(
          state.copyWith(
            status: ChallengeStatus.success,
            challenges: challengeResult.data ?? const [],
            coinBalance: balanceResult.data ?? 0,
          ),
        );
      } else {
        emit(state.copyWith(status: ChallengeStatus.failure));
      }
      return;
    }

    final result = await _repository.getChallenges(
      type: state.selectedFilter.type,
    );
    if (isClosed || requestId != _requestId) return;

    if (result is DataStateSuccess<List<ChallengeModel>>) {
      emit(
        state.copyWith(
          status: ChallengeStatus.success,
          challenges: result.data ?? const [],
        ),
      );
    } else {
      emit(state.copyWith(status: ChallengeStatus.failure));
    }
  }
}

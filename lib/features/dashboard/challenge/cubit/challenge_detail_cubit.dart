import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:runca/config/service_locator.dart';
import 'package:runca/features/dashboard/challenge/models/challenge_model.dart';
import 'package:runca/repository/challenge_repository.dart';
import 'package:runca/utility/resource/data_state.dart';

import 'challenge_detail_state.dart';

class ChallengeDetailCubit extends Cubit<ChallengeDetailState> {
  ChallengeDetailCubit({
    required this.challengeId,
    ChallengeRepository? repository,
  }) : _repository = repository ?? serviceLocator.get<ChallengeRepository>(),
       super(const ChallengeDetailState()) {
    load();
  }

  final String challengeId;
  final ChallengeRepository _repository;
  int _requestId = 0;

  Future<void> load() async {
    final requestId = ++_requestId;
    emit(state.copyWith(status: ChallengeDetailStatus.loading));

    final result = await _repository.getChallengeDetail(challengeId);
    if (isClosed || requestId != _requestId) return;

    if (result is DataStateSuccess<ChallengeDetail>) {
      emit(
        state.copyWith(
          status: ChallengeDetailStatus.success,
          detail: result.data,
        ),
      );
    } else {
      emit(state.copyWith(status: ChallengeDetailStatus.failure));
    }
  }
}

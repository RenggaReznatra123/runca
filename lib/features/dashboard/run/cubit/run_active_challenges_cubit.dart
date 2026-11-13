import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:runca/config/service_locator.dart';
import 'package:runca/features/dashboard/challenge/models/challenge_progress.dart';
import 'package:runca/repository/challenge_repository.dart';
import 'package:runca/utility/resource/data_state.dart';

import 'run_active_challenges_state.dart';

class RunActiveChallengesCubit extends Cubit<RunActiveChallengesState> {
  RunActiveChallengesCubit({ChallengeRepository? repository})
    : _repository = repository ?? serviceLocator.get<ChallengeRepository>(),
      super(const RunActiveChallengesState()) {
    load();
  }

  final ChallengeRepository _repository;

  // Dipakai untuk mengabaikan jawaban lama kalau ada permintaan yang lebih baru.
  int _requestId = 0;

  /// Muat awal dan Try Again.
  Future<void> load() async {
    final requestId = ++_requestId;

    emit(state.copyWith(status: RunActiveChallengesStatus.loading));

    final result = await _repository.getActiveChallengeProgress();

    if (isClosed || requestId != _requestId) return;

    if (result is DataStateSuccess<List<ChallengeProgress>>) {
      emit(
        state.copyWith(
          status: RunActiveChallengesStatus.success,
          challenges: result.data ?? const [],
        ),
      );
    } else {
      emit(state.copyWith(status: RunActiveChallengesStatus.failure));
    }
  }
}

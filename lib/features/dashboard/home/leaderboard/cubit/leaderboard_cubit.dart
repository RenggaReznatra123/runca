import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:runca/config/service_locator.dart';
import 'package:runca/features/dashboard/home/leaderboard/models/leaderboard_model.dart';
import 'package:runca/repository/leaderboard_repository.dart';
import 'package:runca/utility/resource/data_state.dart';

import 'leaderboard_state.dart';

class LeaderboardCubit extends Cubit<LeaderboardState> {
  LeaderboardCubit({LeaderboardRepository? repository})
    : _repository =
          repository ?? serviceLocator.get<LeaderboardRepository>(),
      super(const LeaderboardState()) {
    loadLeaderboard();
  }

  final LeaderboardRepository _repository;
  int _requestId = 0;

  Future<void> loadLeaderboard() => _fetch(showLoading: true);

  void selectPeriod(LeaderboardPeriod period) {
    if (period == state.selectedPeriod) return;
    emit(state.copyWith(selectedPeriod: period));
    _fetch(showLoading: false);
  }

  Future<void> _fetch({required bool showLoading}) async {
    final requestId = ++_requestId;
    if (showLoading) emit(state.copyWith(status: LeaderboardStatus.loading));

    final result = await _repository.getLeaderboard(
      period: state.selectedPeriod,
    );
    if (isClosed || requestId != _requestId) return;

    if (result is DataStateSuccess<LeaderboardData>) {
      final data = result.data;
      emit(
        state.copyWith(
          status: LeaderboardStatus.success,
          runners: data?.runners ?? const [],
          totalRunners: data?.totalRunners ?? 0,
        ),
      );
    } else {
      emit(state.copyWith(status: LeaderboardStatus.failure));
    }
  }
}

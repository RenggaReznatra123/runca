import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:runca/config/service_locator.dart';
import 'package:runca/features/dashboard/home/models/home_model.dart';
import 'package:runca/features/dashboard/profile/models/profile_model.dart';
import 'package:runca/repository/home_repository.dart';
import 'package:runca/repository/profile_repository.dart';
import 'package:runca/utility/resource/data_state.dart';

import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({
    HomeRepository? repository,
    ProfileRepository? profileRepository,
  }) : _repository = repository ?? serviceLocator.get<HomeRepository>(),
       _profileRepository =
           profileRepository ?? serviceLocator.get<ProfileRepository>(),
       super(const HomeState()) {
    loadHome();
  }

  final HomeRepository _repository;
  final ProfileRepository _profileRepository;
  int _requestId = 0;

  Future<void> loadHome() async {
    final requestId = ++_requestId;
    if (state.overview == null) {
      emit(state.copyWith(status: HomeStatus.loading));
    }

    final (overviewResult, statsResult, profileResult) = await (
      _repository.getOverview(),
      _repository.getWeeklyStats(activityType: state.activityType),
      _profileRepository.getProfileData(),
    ).wait;

    if (isClosed || requestId != _requestId) return;

    if (overviewResult is DataStateSuccess<HomeOverview> &&
        statsResult is DataStateSuccess<WeeklyStatsData> &&
        profileResult is DataStateSuccess<ProfileData>) {
      emit(
        state.copyWith(
          status: HomeStatus.success,
          overview: overviewResult.data,
          weeklyStats: statsResult.data,
          profile: profileResult.data?.profile,
          hasError: false,
        ),
      );
    } else if (state.overview == null) {
      emit(state.copyWith(status: HomeStatus.failure));
    } else {
      emit(state.copyWith(hasError: true));
    }
  }

  void selectActivityType(HomeActivityType activityType) {
    if (activityType == state.activityType) return;
    emit(state.copyWith(activityType: activityType));
    _loadWeeklyStats();
  }

  Future<void> _loadWeeklyStats() async {
    final requestId = ++_requestId;
    final result = await _repository.getWeeklyStats(
      activityType: state.activityType,
    );
    if (isClosed || requestId != _requestId) return;

    if (result is DataStateSuccess<WeeklyStatsData>) {
      emit(state.copyWith(weeklyStats: result.data, hasError: false));
    } else {
      emit(state.copyWith(hasError: true));
    }
  }

  void clearError() {
    if (state.hasError) emit(state.copyWith(hasError: false));
  }
}

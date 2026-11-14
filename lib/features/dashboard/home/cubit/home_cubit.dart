import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:runca/config/service_locator.dart';
import 'package:runca/features/dashboard/home/models/home_model.dart';
import 'package:runca/features/dashboard/profile/models/profile_model.dart';
import 'package:runca/repository/home_repository.dart';
import 'package:runca/repository/profile_repository.dart';
import 'package:runca/utility/resource/data_state.dart';

import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({HomeRepository? repository, ProfileRepository? profileRepository})
    : _repository = repository ?? serviceLocator.get<HomeRepository>(),
      _profileRepository =
          profileRepository ?? serviceLocator.get<ProfileRepository>(),
      super(const HomeState()) {
    loadHome();

    // Muat ulang diam-diam kalau ada lari baru (streak dan statistik).
    _changesSubscription = _repository.changes.listen((_) => loadHome());
    _profileChangesSubscription = _profileRepository.changes.listen(
      (_) => _refreshProfile(),
    );
  }

  final HomeRepository _repository;
  final ProfileRepository _profileRepository;
  StreamSubscription<void>? _changesSubscription;
  StreamSubscription<void>? _profileChangesSubscription;
  int _requestId = 0;
  int _profileRequestId = 0;

  Future<void> loadHome() async {
    await _fetchHome(reportError: true);
  }

  Future<bool> refresh() => _fetchHome(reportError: false);

  void reportRefreshError() {
    if (!state.hasError) emit(state.copyWith(hasError: true));
  }

  Future<bool> _fetchHome({required bool reportError}) async {
    final requestId = ++_requestId;
    if (reportError && state.overview == null) {
      emit(state.copyWith(status: HomeStatus.loading));
    }

    final (overviewResult, statsResult, profileResult) = await (
      _repository.getOverview(),
      _repository.getWeeklyStats(activityType: state.activityType),
      _profileRepository.getProfileData(),
    ).wait;

    if (isClosed || requestId != _requestId) return true;

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
      return true;
    } else if (state.overview == null) {
      if (reportError) emit(state.copyWith(status: HomeStatus.failure));
    } else if (reportError) {
      emit(state.copyWith(hasError: true));
    }
    return false;
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

  Future<void> _refreshProfile() async {
    final requestId = ++_profileRequestId;
    final result = await _profileRepository.getProfileData();
    if (isClosed || requestId != _profileRequestId) return;

    if (result is DataStateSuccess<ProfileData>) {
      final profile = result.data?.profile;
      if (profile != null) emit(state.copyWith(profile: profile));
    }
  }

  void clearError() {
    if (state.hasError) emit(state.copyWith(hasError: false));
  }

  @override
  Future<void> close() {
    _changesSubscription?.cancel();
    _profileChangesSubscription?.cancel();
    return super.close();
  }
}

import 'package:runca/features/dashboard/home/models/home_model.dart';
import 'package:runca/features/dashboard/profile/models/profile_model.dart';

enum HomeStatus { loading, success, failure }

class HomeState {
  const HomeState({
    this.status = HomeStatus.loading,
    this.activityType = HomeActivityType.outdoor,
    this.overview,
    this.weeklyStats,
    this.profile,
    this.hasError = false,
  });

  final HomeStatus status;
  final HomeActivityType activityType;
  final HomeOverview? overview;
  final WeeklyStatsData? weeklyStats;
  final ProfileModel? profile;
  final bool hasError;

  HomeState copyWith({
    HomeStatus? status,
    HomeActivityType? activityType,
    HomeOverview? overview,
    WeeklyStatsData? weeklyStats,
    ProfileModel? profile,
    bool? hasError,
  }) {
    return HomeState(
      status: status ?? this.status,
      activityType: activityType ?? this.activityType,
      overview: overview ?? this.overview,
      weeklyStats: weeklyStats ?? this.weeklyStats,
      profile: profile ?? this.profile,
      hasError: hasError ?? this.hasError,
    );
  }
}

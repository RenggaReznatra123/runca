import '../models/profile_model.dart';

enum AchievementsLoadStatus { loading, success, failure }

class AchievementsState {
  const AchievementsState({
    this.status = AchievementsLoadStatus.loading,
    this.filter = AchievementFilter.all,
    this.achievements = const [],
    this.hasRefreshError = false,
  });

  final AchievementsLoadStatus status;
  final AchievementFilter filter;
  final bool hasRefreshError;

  /// Hasil dari repository, sudah terfilter.
  final List<AchievementModel> achievements;

  AchievementsState copyWith({
    AchievementsLoadStatus? status,
    AchievementFilter? filter,
    List<AchievementModel>? achievements,
    bool? hasRefreshError,
  }) {
    return AchievementsState(
      status: status ?? this.status,
      filter: filter ?? this.filter,
      achievements: achievements ?? this.achievements,
      hasRefreshError: hasRefreshError ?? this.hasRefreshError,
    );
  }
}

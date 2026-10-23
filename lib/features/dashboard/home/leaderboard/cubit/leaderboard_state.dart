import '../models/leaderboard_model.dart';

enum LeaderboardStatus { loading, success, failure }

class LeaderboardState {
  const LeaderboardState({
    this.status = LeaderboardStatus.loading,
    this.selectedPeriod = LeaderboardPeriod.thisWeek,
    this.runners = const [],
    this.totalRunners = 0,
  });

  final LeaderboardStatus status;
  final LeaderboardPeriod selectedPeriod;
  final List<LeaderboardRunner> runners;
  final int totalRunners;

  LeaderboardState copyWith({
    LeaderboardStatus? status,
    LeaderboardPeriod? selectedPeriod,
    List<LeaderboardRunner>? runners,
    int? totalRunners,
  }) {
    return LeaderboardState(
      status: status ?? this.status,
      selectedPeriod: selectedPeriod ?? this.selectedPeriod,
      runners: runners ?? this.runners,
      totalRunners: totalRunners ?? this.totalRunners,
    );
  }
}

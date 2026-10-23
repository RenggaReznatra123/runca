
enum LeaderboardPeriod {
  thisWeek,
  thisMonth,
  allTime,
}

class LeaderboardRunner {
  const LeaderboardRunner({
    required this.name,
    required this.distanceKm,
    required this.rank,
    this.isCurrentUser = false,
  });

  final String name;
  final double distanceKm;
  final int rank;
  final bool isCurrentUser;

  String get formattedDistance => '${distanceKm.toStringAsFixed(1)} km';
}

class LeaderboardState {
  const LeaderboardState({
    this.selectedPeriod = LeaderboardPeriod.thisWeek,
    this.runners = const [],
  });

  final LeaderboardPeriod selectedPeriod;
  final List<LeaderboardRunner> runners;

  LeaderboardState copyWith({
    LeaderboardPeriod? selectedPeriod,
    List<LeaderboardRunner>? runners,
  }) {
    return LeaderboardState(
      selectedPeriod: selectedPeriod ?? this.selectedPeriod,
      runners: runners ?? this.runners,
    );
  }
}

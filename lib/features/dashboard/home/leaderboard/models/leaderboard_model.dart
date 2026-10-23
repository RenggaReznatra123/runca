enum LeaderboardPeriod { thisWeek, thisMonth, allTime }

class LeaderboardRunner {
  const LeaderboardRunner({
    required this.rank,
    required this.name,
    required this.distanceKm,
    this.isCurrentUser = false,
    this.avatarUrl,
  });

  final int rank;
  final String name;
  final double distanceKm;
  final bool isCurrentUser;
  final String? avatarUrl;
}

class LeaderboardData {
  const LeaderboardData({
    required this.runners,
    required this.totalRunners,
  });

  final List<LeaderboardRunner> runners;
  final int totalRunners;
}

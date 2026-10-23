enum HomeStatus { initial, loading, loaded }

class HomeState {
  const HomeState({
    this.status = HomeStatus.initial,
    this.streak = 4,
    this.completedDays = const [true, true, true, true, false, false, false],
    this.weeklyDistance = 12.5,
    this.weeklyDuration = 95,
    this.weeklyRuns = 3,
  });

  final HomeStatus status;
  final int streak;
  final List<bool> completedDays;
  final double weeklyDistance;
  final int weeklyDuration;
  final int weeklyRuns;

  HomeState copyWith({
    HomeStatus? status,
    int? streak,
    List<bool>? completedDays,
    double? weeklyDistance,
    int? weeklyDuration,
    int? weeklyRuns,
  }) {
    return HomeState(
      status: status ?? this.status,
      streak: streak ?? this.streak,
      completedDays: completedDays ?? this.completedDays,
      weeklyDistance: weeklyDistance ?? this.weeklyDistance,
      weeklyDuration: weeklyDuration ?? this.weeklyDuration,
      weeklyRuns: weeklyRuns ?? this.weeklyRuns,
    );
  }
}

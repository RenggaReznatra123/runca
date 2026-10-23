import 'package:runca/data/dummy_config.dart';
import 'package:runca/features/dashboard/home/leaderboard/models/leaderboard_model.dart';
import 'package:runca/repository/leaderboard_repository.dart';
import 'package:runca/utility/resource/data_state.dart';

class DummyLeaderboardRepository implements LeaderboardRepository {
  static const LeaderboardData _data = LeaderboardData(
    runners: [
      LeaderboardRunner(rank: 1, name: 'Maya Sari', distanceKm: 142.5),
      LeaderboardRunner(rank: 2, name: 'Raka Pratama', distanceKm: 118.8),
      LeaderboardRunner(rank: 3, name: 'Dimas Arya', distanceKm: 96.4),
      LeaderboardRunner(rank: 4, name: 'Nadia Putri', distanceKm: 82.1),
      LeaderboardRunner(rank: 5, name: 'Bima Santoso', distanceKm: 74.6),
      LeaderboardRunner(rank: 6, name: 'Alya Rahman', distanceKm: 63.8),
      LeaderboardRunner(
        rank: 7,
        name: 'You',
        distanceKm: 56.2,
        isCurrentUser: true,
      ),
      LeaderboardRunner(rank: 8, name: 'Farhan Ilham', distanceKm: 49.7),
    ],
    totalRunners: 24,
  );

  @override
  Future<DataState<LeaderboardData>> getLeaderboard({
    required LeaderboardPeriod period,
  }) async {
    await DummyConfig.simulateNetwork();

    switch (DummyConfig.scenario) {
      case DummyScenario.failure:
        return DummyConfig.failure<LeaderboardData>('/leaderboard');
      case DummyScenario.empty:
        return const DataStateSuccess<LeaderboardData>(
          LeaderboardData(runners: [], totalRunners: 0),
        );
      case DummyScenario.data:
        return const DataStateSuccess<LeaderboardData>(_data);
    }
  }
}

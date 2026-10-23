import 'package:runca/features/dashboard/home/leaderboard/models/leaderboard_model.dart';
import 'package:runca/utility/resource/data_state.dart';

abstract class LeaderboardRepository {
  Future<DataState<LeaderboardData>> getLeaderboard({
    required LeaderboardPeriod period,
  });
}

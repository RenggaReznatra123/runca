
import 'package:flutter_bloc/flutter_bloc.dart';

import 'leaderboard_state.dart';

class LeaderboardCubit extends Cubit<LeaderboardState> {
  LeaderboardCubit() : super(const LeaderboardState()) {
    loadLeaderboard();
  }

  static const List<LeaderboardRunner> _dummyRunners = [
    LeaderboardRunner(
      name: 'Maya Sari',
      distanceKm: 142.5,
      rank: 1,
    ),
    LeaderboardRunner(
      name: 'Raka Pratama',
      distanceKm: 118.8,
      rank: 2,
    ),
    LeaderboardRunner(
      name: 'Dimas Arya',
      distanceKm: 96.4,
      rank: 3,
    ),
    LeaderboardRunner(
      name: 'Nadia Putri',
      distanceKm: 82.1,
      rank: 4,
    ),
    LeaderboardRunner(
      name: 'Bima Santoso',
      distanceKm: 74.6,
      rank: 5,
    ),
    LeaderboardRunner(
      name: 'Alya Rahman',
      distanceKm: 63.8,
      rank: 6,
    ),
    LeaderboardRunner(
      name: 'You',
      distanceKm: 56.2,
      rank: 7,
      isCurrentUser: true,
    ),
    LeaderboardRunner(
      name: 'Farhan Ilham',
      distanceKm: 49.7,
      rank: 8,
    ),
  ];

  void loadLeaderboard() {
    emit(
      state.copyWith(
        runners: List.unmodifiable(_dummyRunners),
      ),
    );
  }

  void selectPeriod(LeaderboardPeriod period) {
    if (period == state.selectedPeriod) return;

    emit(state.copyWith(selectedPeriod: period));
  }
}

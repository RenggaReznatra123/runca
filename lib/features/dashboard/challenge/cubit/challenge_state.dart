import '../models/challenge_model.dart';

enum ChallengeTab { discover, active, history }

enum ChallengeFilter {
  all('All'),
  running('Running'),
  treadmill('Treadmill'),
  walking('Walking');

  const ChallengeFilter(this.label);

  final String label;

  bool matches(ChallengeType type) {
    switch (this) {
      case ChallengeFilter.all:
        return true;
      case ChallengeFilter.running:
        return type == ChallengeType.running;
      case ChallengeFilter.treadmill:
        return type == ChallengeType.treadmill;
      case ChallengeFilter.walking:
        return type == ChallengeType.walking;
    }
  }
}

class ChallengeState {
  const ChallengeState({
    this.selectedTab = ChallengeTab.discover,
    this.selectedFilter = ChallengeFilter.all,
    this.coinBalance = 0,
    this.challenges = const [],
  });

  final ChallengeTab selectedTab;
  final ChallengeFilter selectedFilter;
  final int coinBalance;
  final List<ChallengeModel> challenges;

  /// Daftar yang tampil setelah filter chip diterapkan.
  List<ChallengeModel> get visibleChallenges {
    return challenges
        .where((challenge) => selectedFilter.matches(challenge.type))
        .toList(growable: false);
  }

  ChallengeState copyWith({
    ChallengeTab? selectedTab,
    ChallengeFilter? selectedFilter,
    int? coinBalance,
    List<ChallengeModel>? challenges,
  }) {
    return ChallengeState(
      selectedTab: selectedTab ?? this.selectedTab,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      coinBalance: coinBalance ?? this.coinBalance,
      challenges: challenges ?? this.challenges,
    );
  }
}
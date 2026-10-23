import '../models/challenge_model.dart';

enum ChallengeTab { discover, active, history }

enum ChallengeStatus { loading, success, failure }

enum ChallengeFilter {
  all('All'),
  running('Running'),
  treadmill('Treadmill'),
  walking('Walking');

  const ChallengeFilter(this.label);

  final String label;

  ChallengeType? get type => switch (this) {
    ChallengeFilter.all => null,
    ChallengeFilter.running => ChallengeType.running,
    ChallengeFilter.treadmill => ChallengeType.treadmill,
    ChallengeFilter.walking => ChallengeType.walking,
  };
}

class ChallengeState {
  const ChallengeState({
    this.status = ChallengeStatus.loading,
    this.selectedTab = ChallengeTab.discover,
    this.selectedFilter = ChallengeFilter.all,
    this.coinBalance = 0,
    this.challenges = const [],
  });

  final ChallengeStatus status;
  final ChallengeTab selectedTab;
  final ChallengeFilter selectedFilter;
  final int coinBalance;
  final List<ChallengeModel> challenges;

  ChallengeState copyWith({
    ChallengeStatus? status,
    ChallengeTab? selectedTab,
    ChallengeFilter? selectedFilter,
    int? coinBalance,
    List<ChallengeModel>? challenges,
  }) {
    return ChallengeState(
      status: status ?? this.status,
      selectedTab: selectedTab ?? this.selectedTab,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      coinBalance: coinBalance ?? this.coinBalance,
      challenges: challenges ?? this.challenges,
    );
  }
}
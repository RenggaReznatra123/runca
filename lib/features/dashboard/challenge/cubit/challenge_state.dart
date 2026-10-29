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
    this.activeStatus = ChallengeStatus.loading,
    this.activeChallenges = const [],
    this.historyStatus = ChallengeStatus.loading,
    this.historyFilter = ChallengeFilter.all,
    this.historyChallenges = const [],
  });

  /// Status, filter, dan daftar untuk tab Discover (juga dipakai Home).
  final ChallengeStatus status;
  final ChallengeTab selectedTab;
  final ChallengeFilter selectedFilter;
  final int coinBalance;
  final List<ChallengeModel> challenges;

  /// Tab Active.
  final ChallengeStatus activeStatus;
  final List<ChallengeModel> activeChallenges;

  /// Tab History (punya chip filter sendiri).
  final ChallengeStatus historyStatus;
  final ChallengeFilter historyFilter;
  final List<ChallengeModel> historyChallenges;

  ChallengeState copyWith({
    ChallengeStatus? status,
    ChallengeTab? selectedTab,
    ChallengeFilter? selectedFilter,
    int? coinBalance,
    List<ChallengeModel>? challenges,
    ChallengeStatus? activeStatus,
    List<ChallengeModel>? activeChallenges,
    ChallengeStatus? historyStatus,
    ChallengeFilter? historyFilter,
    List<ChallengeModel>? historyChallenges,
  }) {
    return ChallengeState(
      status: status ?? this.status,
      selectedTab: selectedTab ?? this.selectedTab,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      coinBalance: coinBalance ?? this.coinBalance,
      challenges: challenges ?? this.challenges,
      activeStatus: activeStatus ?? this.activeStatus,
      activeChallenges: activeChallenges ?? this.activeChallenges,
      historyStatus: historyStatus ?? this.historyStatus,
      historyFilter: historyFilter ?? this.historyFilter,
      historyChallenges: historyChallenges ?? this.historyChallenges,
    );
  }
}

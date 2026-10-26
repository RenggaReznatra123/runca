import '../models/reward_model.dart';

enum RewardsStatus { loading, success, failure }

enum RewardFilter {
  all('All', null),
  foodAndBeverage('Food & Beverage', RewardCategory.foodAndBeverage),
  fashion('Fashion', RewardCategory.fashion),
  lifestyle('Lifestyle', RewardCategory.lifestyle);

  const RewardFilter(this.label, this.category);

  final String label;

  /// Kategori yang dikirim ke repository. Null berarti semua.
  final RewardCategory? category;
}

class RewardsState {
  const RewardsState({
    this.status = RewardsStatus.loading,
    this.selectedFilter = RewardFilter.all,
    this.coinBalance = 0,
    this.rewards = const [],
  });

  final RewardsStatus status;
  final RewardFilter selectedFilter;
  final int coinBalance;

  /// Hasil dari repository, sudah terfilter.
  final List<RewardModel> rewards;

  RewardsState copyWith({
    RewardsStatus? status,
    RewardFilter? selectedFilter,
    int? coinBalance,
    List<RewardModel>? rewards,
  }) {
    return RewardsState(
      status: status ?? this.status,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      coinBalance: coinBalance ?? this.coinBalance,
      rewards: rewards ?? this.rewards,
    );
  }
}

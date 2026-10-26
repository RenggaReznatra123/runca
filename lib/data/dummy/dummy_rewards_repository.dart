import 'package:runca/config/app_assets.dart';
import 'package:runca/data/dummy_config.dart';
import 'package:runca/features/dashboard/rewards/models/reward_model.dart';
import 'package:runca/repository/rewards_repository.dart';
import 'package:runca/utility/resource/data_state.dart';

class DummyRewardsRepository implements RewardsRepository {
  /// Saldo dummy. Tiap redeem mengurangi saldo; kalau kurang dari harga
  /// reward (4,000), tampilan "saldo kurang" muncul.
  int _coinBalance = 10000;

  static RewardDetail _gacoan(int number) => RewardDetail(
    id: 'gacoan-$number',
    brandName: 'Mie Gacoan',
    title: 'Free Ujang Kedu',
    category: RewardCategory.foodAndBeverage,
    description:
        'Get one free Ujang Kedu of any size at participating Mie Gacoan '
        'stores. Tasty, spicy, and always a good idea!',
    price: 4000,
    validUntil: DateTime(2027, 8, 31),
    availableAt: 'All Mie Gacoan stores',
    quotaLeft: 48,
    imageUrl: AppAssets.gacoan,
  );

  static RewardDetail _kopken(int number) => RewardDetail(
    id: 'kopken-$number',
    brandName: 'Kopi Kenangan',
    title: 'Diskon 35%',
    category: RewardCategory.foodAndBeverage,
    description:
        'Enjoy a 35% discount on selected drinks at participating Kopi '
        'Kenangan stores.',
    price: 4000,
    validUntil: DateTime(2027, 8, 31),
    availableAt: 'All participating Kopi Kenangan stores',
    quotaLeft: 48,
    imageUrl: AppAssets.kopken,
  );

  static final List<RewardDetail> _catalog = [
    _gacoan(1),
    _kopken(1),
    _gacoan(2),
    _kopken(2),
    _gacoan(3),
    _kopken(3),
  ];

  static RewardModel _toSummary(RewardDetail detail) => RewardModel(
    id: detail.id,
    brandName: detail.brandName,
    title: detail.title,
    category: detail.category,
    price: detail.price,
    imageUrl: detail.imageUrl,
  );

  RewardDetail? _findDetail(String rewardId) {
    for (final detail in _catalog) {
      if (detail.id == rewardId) return detail;
    }
    return null;
  }

  @override
  Future<DataState<RewardsData>> getRewards({RewardCategory? category}) async {
    await DummyConfig.simulateNetwork();

    switch (DummyConfig.scenario) {
      case DummyScenario.failure:
        return DummyConfig.failure<RewardsData>('/rewards');
      case DummyScenario.empty:
        return DataStateSuccess<RewardsData>(
          RewardsData(coinBalance: _coinBalance, rewards: const []),
        );
      case DummyScenario.data:
        break;
    }

    final rewards = _catalog
        .where((detail) => category == null || detail.category == category)
        .map(_toSummary)
        .toList(growable: false);

    return DataStateSuccess<RewardsData>(
      RewardsData(coinBalance: _coinBalance, rewards: rewards),
    );
  }

  @override
  Future<DataState<RewardDetailData>> getRewardDetail(String rewardId) async {
    await DummyConfig.simulateNetwork();

    final detail = _findDetail(rewardId);

    if (DummyConfig.scenario == DummyScenario.failure || detail == null) {
      return DummyConfig.failure<RewardDetailData>('/rewards/$rewardId');
    }

    return DataStateSuccess<RewardDetailData>(
      RewardDetailData(detail: detail, coinBalance: _coinBalance),
    );
  }

  @override
  Future<DataState<RedeemResult>> redeemReward(String rewardId) async {
    await DummyConfig.simulateNetwork();

    final detail = _findDetail(rewardId);

    if (DummyConfig.scenario == DummyScenario.failure ||
        detail == null ||
        _coinBalance < detail.price) {
      return DummyConfig.failure<RedeemResult>('/rewards/$rewardId/redeem');
    }

    _coinBalance -= detail.price;

    return DataStateSuccess<RedeemResult>(
      RedeemResult(remainingBalance: _coinBalance),
    );
  }
}

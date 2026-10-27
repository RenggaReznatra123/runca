import 'dart:math';

import 'package:runca/config/app_assets.dart';
import 'package:runca/data/dummy_config.dart';
import 'package:runca/data/dummy/dummy_wallet.dart';
import 'package:runca/features/dashboard/rewards/models/placoin_transaction_model.dart';
import 'package:runca/features/dashboard/rewards/models/reward_model.dart';
import 'package:runca/repository/rewards_repository.dart';
import 'package:runca/utility/format_utils.dart';
import 'package:runca/utility/resource/data_state.dart';

class DummyRewardsRepository implements RewardsRepository {
  DummyRewardsRepository(this._wallet);

  /// Saldo PlaCoins dipakai bersama dengan halaman lain (Profile, dll).
  /// Tiap redeem mengurangi saldo; kalau kurang dari harga reward (4,000),
  /// tampilan "saldo kurang" muncul.
  final DummyWallet _wallet;

  /// Voucher hasil redeem, disimpan di memori dummy.
  final Map<String, RedeemedVoucher> _vouchers = {};
  int _voucherCounter = 0;
  final Random _random = Random();

  /// Riwayat transaksi, terbaru di indeks 0. Mulai kosong, redeem menambah
  /// transaksi baru.
  final List<PlaCoinTransaction> _history = [];
  int _transactionCounter = 0;

  static const String _codeChars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';

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

  static List<String> _termsFor(RewardDetail detail) => [
    'Show this QR code or voucher code to the cashier before placing your '
        'order.',
    'This voucher entitles you to ${detail.title}.',
    'Cannot be combined with ongoing store promotions, discounts, or '
        'loyalty stamps.',
    'Valid strictly until ${AppFormat.shortDate(detail.validUntil)} at '
        '23:59 WIB. Expired vouchers cannot be refunded.',
  ];

  RewardDetail? _findDetail(String rewardId) {
    for (final detail in _catalog) {
      if (detail.id == rewardId) return detail;
    }
    return null;
  }

  /// Kode acak berbentuk 'A8K2-91XM'.
  String _generateCode() {
    String part() => String.fromCharCodes(
      List.generate(
        4,
        (_) => _codeChars.codeUnitAt(_random.nextInt(_codeChars.length)),
      ),
    );

    return '${part()}-${part()}';
  }

  @override
  Future<DataState<RewardsData>> getRewards({RewardCategory? category}) async {
    await DummyConfig.simulateNetwork();

    switch (DummyConfig.scenario) {
      case DummyScenario.failure:
        return DummyConfig.failure<RewardsData>('/rewards');
      case DummyScenario.empty:
        return DataStateSuccess<RewardsData>(
          RewardsData(coinBalance: _wallet.balance, rewards: const []),
        );
      case DummyScenario.data:
        break;
    }

    final rewards = _catalog
        .where((detail) => category == null || detail.category == category)
        .map(_toSummary)
        .toList(growable: false);

    return DataStateSuccess<RewardsData>(
      RewardsData(coinBalance: _wallet.balance, rewards: rewards),
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
      RewardDetailData(detail: detail, coinBalance: _wallet.balance),
    );
  }

  @override
  Future<DataState<RedeemResult>> redeemReward(String rewardId) async {
    await DummyConfig.simulateNetwork();

    final detail = _findDetail(rewardId);

    if (DummyConfig.scenario == DummyScenario.failure ||
        detail == null ||
        _wallet.balance < detail.price) {
      return DummyConfig.failure<RedeemResult>('/rewards/$rewardId/redeem');
    }

    if (!_wallet.spend(detail.price)) {
      return DummyConfig.failure<RedeemResult>('/rewards/$rewardId/redeem');
    }

    final voucherId = 'voucher-${++_voucherCounter}';
    final code = _generateCode();

    _vouchers[voucherId] = RedeemedVoucher(
      id: voucherId,
      title: detail.title,
      brandName: detail.brandName,
      category: detail.category,
      code: code,
      qrData: 'runca:voucher:$voucherId:$code',
      validUntil: detail.validUntil,
      outlet: detail.availableAt,
      terms: _termsFor(detail),
      imageUrl: detail.imageUrl,
    );

    // Redeem tercatat sebagai transaksi spent di riwayat.
    _history.insert(
      0,
      PlaCoinTransaction(
        id: 'tx-${++_transactionCounter}',
        title: '${detail.title} redeemed',
        createdAt: DateTime.now(),
        amount: -detail.price,
        imageUrl: AppAssets.coinSpentIcon,
      ),
    );

    return DataStateSuccess<RedeemResult>(
      RedeemResult(remainingBalance: _wallet.balance, voucherId: voucherId),
    );
  }

  @override
  Future<DataState<RedeemedVoucher>> getVoucher(String voucherId) async {
    await DummyConfig.simulateNetwork();

    final voucher = _vouchers[voucherId];

    if (DummyConfig.scenario == DummyScenario.failure || voucher == null) {
      return DummyConfig.failure<RedeemedVoucher>('/vouchers/$voucherId');
    }

    return DataStateSuccess<RedeemedVoucher>(voucher);
  }

  @override
  Future<DataState<List<PlaCoinTransaction>>> getCoinHistory({
    PlaCoinHistoryFilter filter = PlaCoinHistoryFilter.all,
  }) async {
    await DummyConfig.simulateNetwork();

    switch (DummyConfig.scenario) {
      case DummyScenario.failure:
        return DummyConfig.failure<List<PlaCoinTransaction>>(
          '/placoins/history',
        );
      case DummyScenario.empty:
        return const DataStateSuccess<List<PlaCoinTransaction>>([]);
      case DummyScenario.data:
        break;
    }

    bool matches(PlaCoinTransaction transaction) => switch (filter) {
      PlaCoinHistoryFilter.all => true,
      PlaCoinHistoryFilter.earned => transaction.amount > 0,
      PlaCoinHistoryFilter.spent => transaction.amount < 0,
    };

    final items = _history.where(matches).toList(growable: false);

    return DataStateSuccess<List<PlaCoinTransaction>>(items);
  }

  @override
  Future<DataState<List<EarnMethod>>> getEarnMethods() async {
    await DummyConfig.simulateNetwork();

    if (DummyConfig.scenario == DummyScenario.failure) {
      return DummyConfig.failure<List<EarnMethod>>('/placoins/earn-methods');
    }

    return const DataStateSuccess<List<EarnMethod>>([
      EarnMethod(
        type: EarnMethodType.events,
        title: 'Join Events & Challenges',
        description:
            'Participate in organized community events or complete running '
            'challenges.',
      ),
      EarnMethod(
        type: EarnMethodType.dailyRuns,
        title: 'Daily Runs & Tracking',
        description:
            'Log your daily run activity to keep earning every single day.',
      ),
      EarnMethod(
        type: EarnMethodType.streak,
        title: 'Daily Run Streak',
        description:
            'Maintain your daily running streak to unlock extra bonus '
            'multipliers.',
      ),
    ]);
  }
}

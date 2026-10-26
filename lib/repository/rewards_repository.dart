import 'package:runca/features/dashboard/rewards/models/reward_model.dart';
import 'package:runca/utility/resource/data_state.dart';

/// Kontrak data Rewards. Cubit hanya mengenal kelas ini.
abstract class RewardsRepository {
  /// Daftar reward dan saldo PlaCoins. [category] null berarti semua kategori.
  Future<DataState<RewardsData>> getRewards({RewardCategory? category});

  /// Detail satu reward beserta saldo PlaCoins saat ini.
  Future<DataState<RewardDetailData>> getRewardDetail(String rewardId);

  /// Menukar reward. Server yang memeriksa kecukupan saldo.
  Future<DataState<RedeemResult>> redeemReward(String rewardId);
}

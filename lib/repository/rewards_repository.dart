import 'package:runca/features/dashboard/rewards/models/placoin_transaction_model.dart';
import 'package:runca/features/dashboard/rewards/models/reward_model.dart';
import 'package:runca/utility/resource/data_state.dart';
import 'package:runca/features/dashboard/rewards/models/my_voucher_model.dart';

/// Kontrak data Rewards. Cubit hanya mengenal kelas ini.
abstract class RewardsRepository {
  /// Daftar reward dan saldo PlaCoins. [category] null berarti semua kategori.
  Future<DataState<RewardsData>> getRewards({RewardCategory? category});

  /// Detail satu reward beserta saldo PlaCoins saat ini.
  Future<DataState<RewardDetailData>> getRewardDetail(String rewardId);

  /// Menukar reward. Server yang memeriksa kecukupan saldo.
  Future<DataState<RedeemResult>> redeemReward(String rewardId);

  /// Voucher milik pengguna hasil penukaran (kode, QR, syarat).
  Future<DataState<RedeemedVoucher>> getVoucher(String voucherId);

  /// Daftar voucher milik pengguna, difilter menurut [status].
  Future<DataState<List<MyVoucherSummary>>> getMyVouchers({
    VoucherStatus status = VoucherStatus.active,
  });

  /// Riwayat transaksi PlaCoins, terbaru di atas.
  Future<DataState<List<PlaCoinTransaction>>> getCoinHistory({
    PlaCoinHistoryFilter filter = PlaCoinHistoryFilter.all,
  });

  /// Daftar cara mendapatkan PlaCoins.
  Future<DataState<List<EarnMethod>>> getEarnMethods();
}

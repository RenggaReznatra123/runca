enum RewardCategory {
  foodAndBeverage('Food & Beverage'),
  fashion('Fashion'),
  lifestyle('Lifestyle');

  const RewardCategory(this.label);

  final String label;
}

/// Ringkasan reward untuk kartu di daftar.
class RewardModel {
  const RewardModel({
    required this.id,
    required this.brandName,
    required this.title,
    required this.category,
    required this.price,
    this.imageUrl,
  });

  final String id;
  final String brandName;

  /// Judul voucher tanpa nama brand, contoh: 'Free Ujang Kedu'.
  final String title;
  final RewardCategory category;

  /// Harga dalam PlaCoins.
  final int price;

  /// URL atau path aset gambar.
  final String? imageUrl;
}

/// Detail reward untuk halaman detail voucher.
class RewardDetail {
  const RewardDetail({
    required this.id,
    required this.brandName,
    required this.title,
    required this.category,
    required this.description,
    required this.price,
    required this.validUntil,
    required this.availableAt,
    required this.quotaLeft,
    this.imageUrl,
    this.brandLogoUrl,
  });

  final String id;
  final String brandName;
  final String title;
  final RewardCategory category;
  final String description;
  final int price;
  final DateTime validUntil;
  final String availableAt;
  final int quotaLeft;
  final String? imageUrl;
  final String? brandLogoUrl;
}

class RewardsData {
  const RewardsData({required this.coinBalance, required this.rewards});

  final int coinBalance;
  final List<RewardModel> rewards;
}

class RewardDetailData {
  const RewardDetailData({required this.detail, required this.coinBalance});

  final RewardDetail detail;
  final int coinBalance;
}

class RedeemResult {
  const RedeemResult({required this.remainingBalance, required this.voucherId});

  final int remainingBalance;

  /// ID voucher milik pengguna hasil penukaran.
  final String voucherId;
}

/// Voucher milik pengguna setelah ditukar (punya kode dan QR).
class RedeemedVoucher {
  const RedeemedVoucher({
    required this.id,
    required this.title,
    required this.brandName,
    required this.category,
    required this.code,
    required this.qrData,
    required this.validUntil,
    required this.outlet,
    required this.terms,
    this.imageUrl,
  });

  final String id;
  final String title;
  final String brandName;
  final RewardCategory category;

  /// Kode voucher yang bisa disebut ke kasir.
  final String code;

  /// Isi QR code (string yang dibaca kasir).
  final String qrData;
  final DateTime validUntil;

  /// Outlet yang menerima voucher.
  final String outlet;

  /// Poin-poin cara pakai dan syarat, urut dari atas.
  final List<String> terms;
  final String? imageUrl;
}

/// Jenis cara mendapatkan PlaCoins. Ikon dan warna dipetakan di widget.
enum EarnMethodType { events, dailyRuns, streak }

/// Satu cara mendapatkan PlaCoins.
class EarnMethod {
  const EarnMethod({
    required this.type,
    required this.title,
    required this.description,
  });

  final EarnMethodType type;
  final String title;
  final String description;
}

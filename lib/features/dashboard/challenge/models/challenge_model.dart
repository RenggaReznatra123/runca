import 'package:intl/intl.dart';

enum ChallengeType {
  running('Running'),
  treadmill('Treadmill'),
  walking('Walking');

  const ChallengeType(this.label);

  final String label;
}

class ChallengeModel {
  const ChallengeModel({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.rewardCoins,
    required this.timeLeft,
    required this.about,
    required this.dateRange,
    required this.target,
    required this.requirements,
    this.imageAsset,
    this.bannerAsset,
  });

  final String id;
  final ChallengeType type;
  final String title;

  /// Deskripsi singkat untuk kartu di daftar.
  final String description;

  /// Jumlah hadiah dalam koin, contoh: 5000.
  final int rewardCoins;

  /// Teks sisa waktu apa adanya, contoh: '3 days left'.
  final String timeLeft;

  /// Deskripsi lengkap untuk halaman detail.
  final String about;

  /// Rentang tanggal apa adanya, contoh: '03 Jul 2026 - 07 Jul 2026'.
  final String dateRange;

  /// Target apa adanya, contoh: '5 KM'.
  final String target;

  final List<String> requirements;

  /// Path aset poster kecil untuk daftar, contoh:
  /// 'assets/images/challenge_running_10k.png'.
  final String? imageAsset;

  /// Path aset banner untuk halaman detail, contoh:
  /// 'assets/images/challenge_detail_banner.png'.
  final String? bannerAsset;

  /// Hadiah dengan pemisah ribuan, contoh: '5,000'.
  String get formattedReward => NumberFormat('#,###').format(rewardCoins);
}
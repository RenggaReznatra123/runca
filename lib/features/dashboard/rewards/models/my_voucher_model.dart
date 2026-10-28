import 'reward_model.dart';

/// Status voucher milik pengguna.
enum VoucherStatus {
  active('Active'),
  used('Used'),
  expired('Expired');

  const VoucherStatus(this.label);

  final String label;
}

/// Ringkasan voucher untuk kartu di halaman My Voucher.
class MyVoucherSummary {
  const MyVoucherSummary({
    required this.id,
    required this.title,
    required this.brandName,
    required this.category,
    required this.validUntil,
    required this.status,
    this.imageUrl,
  });

  final String id;
  final String title;
  final String brandName;
  final RewardCategory category;
  final DateTime validUntil;
  final VoucherStatus status;

  /// URL atau path aset gambar.
  final String? imageUrl;
}

/// Progres satu challenge yang sedang diikuti (data mentah).
class ChallengeProgress {
  const ChallengeProgress({
    required this.id,
    required this.title,
    required this.currentKm,
    required this.targetKm,
    this.imageUrl,
  });

  /// ID challenge, dipakai untuk membuka halaman detailnya.
  final String id;
  final String title;

  /// Jarak yang sudah ditempuh (km).
  final double currentKm;

  /// Jarak target challenge (km).
  final double targetKm;

  final String? imageUrl;

  /// Pencapaian 0.0 sampai 1.0.
  double get fraction {
    if (targetKm <= 0) return 0;

    return (currentKm / targetKm).clamp(0.0, 1.0);
  }
}
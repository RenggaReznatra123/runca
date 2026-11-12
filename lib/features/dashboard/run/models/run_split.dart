/// Pace satu split (satu lap Auto Lap).
class RunSplit {
  const RunSplit({
    required this.index,
    required this.distanceKm,
    required this.paceSecondsPerKm,
    required this.deltaSeconds,
    this.isCurrent = false,
  });

  /// Nomor split, mulai dari 1.
  final int index;

  /// Jarak akhir split dari awal lari (km), contoh 0.5, 1.0, 1.5.
  final double distanceKm;

  /// Pace split dalam detik per km.
  final int paceSecondsPerKm;

  /// Selisih pace dengan split sebelumnya (negatif = lebih cepat).
  /// Null untuk split pertama.
  final int? deltaSeconds;

  /// True untuk split yang masih berjalan.
  final bool isCurrent;
}
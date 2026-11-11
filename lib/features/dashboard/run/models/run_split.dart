/// Pace satu kilometer.
class RunSplit {
  const RunSplit({
    required this.km,
    required this.paceSecondsPerKm,
    required this.deltaSeconds,
    this.isCurrent = false,
  });

  final int km;
  final int paceSecondsPerKm;

  /// Selisih pace dengan km sebelumnya (negatif = lebih cepat).
  /// Null untuk km pertama.
  final int? deltaSeconds;

  /// True untuk km yang masih berjalan.
  final bool isCurrent;
}
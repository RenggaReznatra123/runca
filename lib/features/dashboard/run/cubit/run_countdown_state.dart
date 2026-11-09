class RunCountdownState {
  const RunCountdownState({required this.remaining, this.finished = false});

  /// Angka yang tampil di lingkaran (3, 2, 1).
  final int remaining;

  /// True saat hitung mundur habis dan lari boleh dimulai.
  final bool finished;
}

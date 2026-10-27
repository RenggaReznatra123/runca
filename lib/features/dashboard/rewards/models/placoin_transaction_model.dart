enum PlaCoinHistoryFilter {
  all('All'),
  earned('Earned'),
  spent('Spent');

  const PlaCoinHistoryFilter(this.label);

  final String label;
}

/// Satu transaksi PlaCoins.
class PlaCoinTransaction {
  const PlaCoinTransaction({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.amount,
    this.imageUrl,
  });

  final String id;
  final String title;
  final DateTime createdAt;

  /// Jumlah koin bertanda: positif = didapat, negatif = dipakai.
  final int amount;

  /// URL atau path aset gambar.
  final String? imageUrl;
}

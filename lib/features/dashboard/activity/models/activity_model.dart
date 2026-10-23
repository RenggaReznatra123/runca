enum ActivityType {
  running('Running'),
  treadmill('Treadmill'),
  cycling('Cycling');

  const ActivityType(this.label);

  final String label;
}

class ActivityModel {
  const ActivityModel({
    required this.id,
    required this.type,
    required this.title,
    required this.startedAt,
    required this.distanceKm,
    required this.durationSeconds,
    required this.avgPaceSecondsPerKm,
    required this.calories,
    this.mapImageUrl,
  });

  final String id;
  final ActivityType type;
  final String title;
  final DateTime startedAt;

  /// Jarak dalam kilometer, contoh: 8.4
  final double distanceKm;

  /// Durasi dalam detik, contoh: 2616
  final int durationSeconds;

  /// Pace rata-rata dalam detik per kilometer, contoh: 311
  final int avgPaceSecondsPerKm;

  /// Kalori dalam kkal.
  final int calories;

  /// URL (atau path aset) gambar peta. Kalau null atau gagal dimuat,
  /// ditampilkan kotak placeholder.
  final String? mapImageUrl;
}
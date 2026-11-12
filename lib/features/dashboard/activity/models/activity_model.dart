enum ActivityType {
  running('Running'),
  treadmill('Treadmill'),
  cycling('Cycling');

  const ActivityType(this.label);

  final String label;
}

/// Satu titik rute (data mentah, tanpa akurasi).
class RoutePoint {
  const RoutePoint({required this.latitude, required this.longitude});

  final double latitude;
  final double longitude;
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
    this.route = const [],
    this.steps,
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

  /// URL (atau path aset) gambar peta. Dipakai kalau [route] kosong.
  final String? mapImageUrl;

  /// Titik rute untuk menggambar peta. Kosong kalau tidak ada GPS.
  final List<RoutePoint> route;

  /// Jumlah langkah. Hanya ada untuk Treadmill, selain itu null.
  final int? steps;

  ActivityModel copyWith({String? title}) {
    return ActivityModel(
      id: id,
      type: type,
      title: title ?? this.title,
      startedAt: startedAt,
      distanceKm: distanceKm,
      durationSeconds: durationSeconds,
      avgPaceSecondsPerKm: avgPaceSecondsPerKm,
      calories: calories,
      mapImageUrl: mapImageUrl,
      route: route,
      steps: steps,
    );
  }
}
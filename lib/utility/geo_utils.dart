import 'dart:math' as math;

/// Hitungan geografi sederhana.
class GeoUtils {
  const GeoUtils._();

  static const double _earthRadiusMeters = 6371000;

  /// Jarak dua titik koordinat dalam meter (rumus haversine).
  static double distanceMeters(
    double lat1,
    double lng1,
    double lat2,
    double lng2,
  ) {
    final dLat = _radians(lat2 - lat1);
    final dLng = _radians(lng2 - lng1);

    final a =
        math.pow(math.sin(dLat / 2), 2) +
        math.cos(_radians(lat1)) *
            math.cos(_radians(lat2)) *
            math.pow(math.sin(dLng / 2), 2);

    return 2 * _earthRadiusMeters * math.asin(math.min(1, math.sqrt(a)));
  }

  static double _radians(double degrees) => degrees * math.pi / 180;
}
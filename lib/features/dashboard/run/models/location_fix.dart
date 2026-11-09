/// Satu pembacaan lokasi dari GPS.
class LocationFix {
  const LocationFix({
    required this.latitude,
    required this.longitude,
    required this.accuracyMeters,
  });

  final double latitude;
  final double longitude;

  /// Perkiraan ketelitian dalam meter (makin kecil makin teliti).
  final double accuracyMeters;
}

/// Hasil pemeriksaan izin lokasi.
enum LocationPermissionResult {
  granted,
  denied,
  deniedForever,
  serviceDisabled,
}

import 'package:runca/features/dashboard/run/models/location_fix.dart';

/// Kontrak lokasi perangkat. Berbeda dari repository lain, lokasi berupa
/// stream karena datang terus-menerus dari sensor GPS, bukan dari server.
/// Implementasi: GeolocatorLocationRepository (GPS asli) dan
/// DummyLocationRepository (simulasi untuk emulator tanpa GPS).
abstract class LocationRepository {
  /// Memeriksa layanan lokasi dan izin tanpa menampilkan dialog.
  Future<LocationPermissionResult> checkPermission();

  /// Meminta izin lokasi (menampilkan dialog sistem).
  Future<LocationPermissionResult> requestPermission();

  /// Lokasi pengguna secara terus-menerus.
  Stream<LocationFix> watchLocation();

  Future<void> openAppSettings();

  Future<void> openLocationSettings();
}
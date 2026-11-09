import 'package:runca/config/map_config.dart';
import 'package:runca/features/dashboard/run/models/location_fix.dart';
import 'package:runca/repository/location_repository.dart';

/// Lokasi simulasi (diam di Simpang Lima) untuk emulator tanpa GPS.
class DummyLocationRepository implements LocationRepository {
  static const LocationFix _position = LocationFix(
    latitude: MapConfig.defaultLatitude,
    longitude: MapConfig.defaultLongitude,
    accuracyMeters: 8,
  );

  @override
  Future<LocationPermissionResult> checkPermission() async {
    return LocationPermissionResult.granted;
  }

  @override
  Future<LocationPermissionResult> requestPermission() async {
    return LocationPermissionResult.granted;
  }

  @override
  Stream<LocationFix> watchLocation() async* {
    yield _position;
    yield* Stream<LocationFix>.periodic(
      const Duration(seconds: 3),
      (_) => _position,
    );
  }

  @override
  Future<void> openAppSettings() async {}

  @override
  Future<void> openLocationSettings() async {}
}

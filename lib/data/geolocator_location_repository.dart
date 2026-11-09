import 'package:geolocator/geolocator.dart';

import 'package:runca/features/dashboard/run/models/location_fix.dart';
import 'package:runca/repository/location_repository.dart';

/// Lokasi dari GPS perangkat (package geolocator).
class GeolocatorLocationRepository implements LocationRepository {
  static const LocationSettings _settings = LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 3,
  );

  @override
  Future<LocationPermissionResult> checkPermission() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      return LocationPermissionResult.serviceDisabled;
    }

    return _map(await Geolocator.checkPermission());
  }

  @override
  Future<LocationPermissionResult> requestPermission() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      return LocationPermissionResult.serviceDisabled;
    }

    return _map(await Geolocator.requestPermission());
  }

  @override
  Stream<LocationFix> watchLocation() {
    return Geolocator.getPositionStream(locationSettings: _settings).map(
      (position) => LocationFix(
        latitude: position.latitude,
        longitude: position.longitude,
        accuracyMeters: position.accuracy,
      ),
    );
  }

  @override
  Future<void> openAppSettings() async {
    await Geolocator.openAppSettings();
  }

  @override
  Future<void> openLocationSettings() async {
    await Geolocator.openLocationSettings();
  }

  LocationPermissionResult _map(LocationPermission permission) {
    return switch (permission) {
      LocationPermission.always ||
      LocationPermission.whileInUse => LocationPermissionResult.granted,
      LocationPermission.deniedForever =>
        LocationPermissionResult.deniedForever,
      LocationPermission.denied ||
      LocationPermission.unableToDetermine => LocationPermissionResult.denied,
    };
  }
}

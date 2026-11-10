import 'dart:async';
import 'dart:math' as math;

import 'package:runca/config/map_config.dart';
import 'package:runca/features/dashboard/run/models/location_fix.dart';
import 'package:runca/repository/location_repository.dart';

/// Lokasi simulasi untuk emulator tanpa GPS: titik bergerak sendiri
/// mengitari rute kecil di sekitar Simpang Lima.
///
/// Posisi dipakai bersama oleh semua pendengar, jadi layar Setup dan
/// layar Tracking melihat titik yang berkelanjutan (tidak melompat).
class DummyLocationRepository implements LocationRepository {
  DummyLocationRepository() {
    _controller = StreamController<LocationFix>.broadcast(
      onListen: _startTimer,
      onCancel: _stopTimerIfIdle,
    );
  }

  // Kecepatan lari tiruan (m/s). 4 m/s = pace sekitar 4'10"/km.
  // Batas filter Tracking: 12 m/s untuk lari, 25 m/s untuk sepeda.
  static const double _speedMetersPerSecond = 4;

  // Jeda antar titik GPS tiruan.
  static const Duration _tick = Duration(seconds: 1);

  // Akurasi tiruan (harus di bawah 30 m supaya dihitung).
  static const double _accuracyMeters = 8;

  // Rute dalam meter dari titik awal: (timur, utara). Berbentuk loop tertutup.
  static const List<(double, double)> _waypoints = [
    (0, 0),
    (220, 0),
    (260, 120),
    (120, 220),
    (-40, 150),
    (0, 0),
  ];

  late final StreamController<LocationFix> _controller;
  Timer? _timer;

  // Jarak yang sudah ditempuh sepanjang rute (meter).
  double _travelled = 0;

  late final List<double> _segmentLengths = [
    for (var i = 0; i < _waypoints.length - 1; i++)
      _distance(_waypoints[i], _waypoints[i + 1]),
  ];

  late final double _totalLength = _segmentLengths.fold(0, (a, b) => a + b);

  static double _distance((double, double) a, (double, double) b) {
    final dx = b.$1 - a.$1;
    final dy = b.$2 - a.$2;
    return math.sqrt(dx * dx + dy * dy);
  }

  void _startTimer() {
    _timer ??= Timer.periodic(_tick, (_) {
      _travelled += _speedMetersPerSecond * _tick.inSeconds;
      _controller.add(_currentFix());
    });
  }

  void _stopTimerIfIdle() {
    if (_controller.hasListener) return;

    _timer?.cancel();
    _timer = null;
  }

  /// Titik pada rute sesuai jarak yang sudah ditempuh (loop berulang).
  LocationFix _currentFix() {
    var remaining = _travelled % _totalLength;
    var east = 0.0;
    var north = 0.0;

    for (var i = 0; i < _segmentLengths.length; i++) {
      final length = _segmentLengths[i];

      if (remaining <= length) {
        final from = _waypoints[i];
        final to = _waypoints[i + 1];
        final t = length == 0 ? 0 : remaining / length;
        east = from.$1 + (to.$1 - from.$1) * t;
        north = from.$2 + (to.$2 - from.$2) * t;
        break;
      }

      remaining -= length;
    }

    const metersPerDegreeLat = 111320.0;
    final metersPerDegreeLon =
        metersPerDegreeLat *
        math.cos(MapConfig.defaultLatitude * math.pi / 180);

    return LocationFix(
      latitude: MapConfig.defaultLatitude + north / metersPerDegreeLat,
      longitude: MapConfig.defaultLongitude + east / metersPerDegreeLon,
      accuracyMeters: _accuracyMeters,
    );
  }

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
    yield _currentFix();
    yield* _controller.stream;
  }

  @override
  Future<void> openAppSettings() async {}

  @override
  Future<void> openLocationSettings() async {}
}

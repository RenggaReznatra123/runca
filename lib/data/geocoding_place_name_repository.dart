import 'package:geocoding/geocoding.dart';

import 'package:runca/repository/place_name_repository.dart';

/// Nama tempat dari package geocoding (butuh internet).
class GeocodingPlaceNameRepository implements PlaceNameRepository {
  final Geocoding _geocoding = Geocoding();

  @override
  Future<String?> getPlaceName({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final places = await _geocoding.placemarkFromCoordinates(
        latitude,
        longitude,
      );

      if (places.isEmpty) return null;

      final place = places.first;
      final parts = <String>[
        if (place.subLocality?.isNotEmpty ?? false) place.subLocality!,
        if (place.locality?.isNotEmpty ?? false) place.locality!,
      ];

      return parts.isEmpty ? null : parts.join(', ');
    } catch (_) {
      return null;
    }
  }
}

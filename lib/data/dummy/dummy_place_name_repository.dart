import 'package:runca/repository/place_name_repository.dart';

/// Nama tempat tiruan, supaya Preview share bisa diuji tanpa internet.
class DummyPlaceNameRepository implements PlaceNameRepository {
  @override
  Future<String?> getPlaceName({
    required double latitude,
    required double longitude,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));

    return 'Simpang Lima, Semarang';
  }
}

/// Kontrak nama tempat dari koordinat (untuk kartu Preview share).
/// Berbeda dari repository lain, hasilnya String? biasa: null berarti
/// nama tempat tidak ditemukan, tampilan tinggal menyembunyikan barisnya.
/// Implementasi: GeocodingPlaceNameRepository (asli) dan
/// DummyPlaceNameRepository (simulasi).
abstract class PlaceNameRepository {
  Future<String?> getPlaceName({
    required double latitude,
    required double longitude,
  });
}

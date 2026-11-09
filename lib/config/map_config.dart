/// Pengaturan peta. Kalau penyedia peta diganti, ubah di sini saja.
class MapConfig {
  const MapConfig._();

  /// Server tile publik OpenStreetMap (cukup untuk uji coba, bukan untuk
  /// pemakaian ramai).
  static const String tileUrlTemplate =
      'https://tile.openstreetmap.org/{z}/{x}/{y}.png';

  /// Nama aplikasi yang dikirim ke server tile.
  static const String userAgentPackageName = 'com.example.runca';

  /// Sumber data peta (wajib tampil untuk OpenStreetMap).
  static const String attribution = '\u00A9 OpenStreetMap contributors';

  /// Pusat peta sebelum lokasi pengguna didapat (sekitar Simpang Lima,
  /// Semarang).
  static const double defaultLatitude = -6.9904;
  static const double defaultLongitude = 110.4229;

  static const double defaultZoom = 15;
  static const double followZoom = 17;
  static const double maxZoom = 19;
}

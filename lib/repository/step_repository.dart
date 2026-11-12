/// Kontrak sumber langkah untuk Treadmill. Seperti lokasi, langkah datang
/// terus-menerus, jadi berbentuk stream.
/// Implementasi saat ini: DummyStepRepository (simulasi). Sensor asli
/// menyusul dan cukup mengganti registrasi di repository_locator.dart.
abstract class StepRepository {
  /// Setiap event = jumlah langkah BARU sejak event sebelumnya.
  Stream<int> watchSteps();
}
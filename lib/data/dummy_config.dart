import 'package:dio/dio.dart';

import 'package:runca/utility/resource/data_state.dart';

enum DummyScenario { data, empty, failure }

/// Pengaturan semua repository dummy, di satu tempat.
class DummyConfig {
  const DummyConfig._();

  /// Untuk menguji tampilan sebelum backend ada. Ubah nilainya lalu
  /// Hot Restart (bukan Hot Reload):
  /// - data    : data seperti di Figma
  /// - empty   : tampilan "belum ada data"
  /// - failure : tampilan gagal memuat
  static const DummyScenario scenario = DummyScenario.data;

  /// Jeda tiruan jaringan, supaya tampilan loading ikut teruji.
  static const Duration latency = Duration(milliseconds: 600);

  static Future<void> simulateNetwork() => Future<void>.delayed(latency);

  /// Hasil gagal yang bentuknya sama dengan kegagalan API sungguhan.
  static DataStateError<T> failure<T>(String path) {
    return DataStateError<T>(
      DioException(
        requestOptions: RequestOptions(path: path),
        type: DioExceptionType.connectionError,
        message:
            'No internet connection. Please check your internet connection.',
      ),
    );
  }
}

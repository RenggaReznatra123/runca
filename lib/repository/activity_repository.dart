import 'package:runca/features/dashboard/activity/models/activity_model.dart';
import 'package:runca/utility/resource/data_state.dart';

/// Kontrak data aktivitas. Cubit hanya mengenal kelas ini.
/// Implementasi: DummyActivityRepository (sekarang), repository API (nanti).
abstract class ActivityRepository {
  /// [type] null berarti semua jenis. [query] null atau kosong berarti
  /// tanpa pencarian.
  Future<DataState<List<ActivityModel>>> getActivities({
    ActivityType? type,
    String? query,
  });
}

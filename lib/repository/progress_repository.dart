import 'package:runca/features/dashboard/activity/models/activity_model.dart';
import 'package:runca/features/dashboard/activity/progress/models/progress_model.dart';
import 'package:runca/utility/resource/data_state.dart';

/// Kontrak data tab Progress. Cubit hanya mengenal kelas ini.
abstract class ProgressRepository {
  /// Statistik untuk satu periode dan tanggal. [type] null berarti semua jenis.
  Future<DataState<ProgressStats>> getStats({
    required ProgressPeriod period,
    required DateTime date,
    ActivityType? type,
  });

  Future<DataState<PersonalRecords>> getPersonalRecords();
}
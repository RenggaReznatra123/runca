import 'package:runca/features/dashboard/activity/models/activity_draft.dart';
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

  /// Satu aktivitas berdasarkan id, untuk halaman detail.
  Future<DataState<ActivityModel>> getActivityDetail({required String id});

  /// Menyimpan lari yang baru selesai. Mengembalikan aktivitas tersimpan.
  Future<DataState<ActivityModel>> saveActivity(ActivityDraft draft);

  /// Mengganti judul aktivitas.
  Future<DataState<ActivityModel>> renameActivity({
    required String id,
    required String title,
  });

  /// Memberi sinyal setiap kali daftar aktivitas berubah (simpan, ubah nama),
  /// supaya Home dan tab Activity memuat ulang.
  Stream<void> get changes;
}

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:runca/config/service_locator.dart';
import 'package:runca/features/dashboard/activity/models/activity_draft.dart';
import 'package:runca/features/dashboard/activity/models/activity_model.dart';
import 'package:runca/repository/activity_repository.dart';
import 'package:runca/utility/resource/data_state.dart';

import 'run_summary_state.dart';

/// Menyimpan lari yang baru selesai begitu layar ringkasan dibuka,
/// lalu mengurus perubahan judulnya.
class RunSummaryCubit extends Cubit<RunSummaryState> {
  RunSummaryCubit({required this._draft, ActivityRepository? repository})
    : _repository = repository ?? serviceLocator.get<ActivityRepository>(),
      super(const RunSummaryState()) {
    save();
  }

  final ActivityDraft _draft;
  final ActivityRepository _repository;

  /// Simpan awal dan tombol Try Again.
  Future<void> save() async {
    if (state.status == RunSummaryStatus.saved) return;

    emit(const RunSummaryState());

    final result = await _repository.saveActivity(_draft);

    if (isClosed) return;

    if (result is DataStateSuccess<ActivityModel> && result.data != null) {
      emit(
        RunSummaryState(status: RunSummaryStatus.saved, activity: result.data),
      );
    } else {
      emit(const RunSummaryState(status: RunSummaryStatus.failure));
    }
  }

  /// Mengembalikan true kalau judul berhasil diganti.
  Future<bool> rename(String title) async {
    final activity = state.activity;
    final trimmed = title.trim();

    if (activity == null || trimmed.isEmpty) return false;

    final result = await _repository.renameActivity(
      id: activity.id,
      title: trimmed,
    );

    if (isClosed) return false;

    if (result is DataStateSuccess<ActivityModel> && result.data != null) {
      emit(state.copyWith(activity: result.data));
      return true;
    }

    return false;
  }
}

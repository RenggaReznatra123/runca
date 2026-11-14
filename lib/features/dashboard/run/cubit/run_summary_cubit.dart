import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:runca/config/service_locator.dart';
import 'package:runca/features/dashboard/activity/models/activity_draft.dart';
import 'package:runca/features/dashboard/activity/models/activity_model.dart';
import 'package:runca/repository/activity_repository.dart';
import 'package:runca/repository/photo_picker_repository.dart';
import 'package:runca/utility/resource/data_state.dart';

import 'run_summary_state.dart';

/// Menyimpan lari yang baru selesai begitu layar ringkasan dibuka,
/// lalu mengurus perubahan judulnya.
class RunSummaryCubit extends Cubit<RunSummaryState> {
  RunSummaryCubit({
    required this._draft,
    ActivityRepository? repository,
    PhotoPickerRepository? photoPicker,
  }) : _repository = repository ?? serviceLocator.get<ActivityRepository>(),
       _photoPicker =
           photoPicker ?? serviceLocator.get<PhotoPickerRepository>(),
       super(const RunSummaryState()) {
    save();
  }

  final ActivityDraft _draft;
  final ActivityRepository _repository;
  final PhotoPickerRepository _photoPicker;
  bool _photoBusy = false;

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

    if (state.status != RunSummaryStatus.saved ||
        activity == null ||
        activity.id.isEmpty ||
        trimmed.isEmpty) {
      return false;
    }

    final result = await _repository.updateActivity(
      id: activity.id,
      title: trimmed,
      photoPath: activity.photoPath,
    );

    if (isClosed) return false;

    if (result is DataStateSuccess<ActivityModel> && result.data != null) {
      emit(state.copyWith(activity: result.data));
      return true;
    }

    return false;
  }

  Future<void> pickPhoto() async {
    final activity = state.activity;

    if (state.status != RunSummaryStatus.saved ||
        activity == null ||
        activity.id.isEmpty ||
        _photoBusy) {
      return;
    }

    _photoBusy = true;

    try {
      final path = await _photoPicker.pickFromGallery();
      if (isClosed || path == null) return;

      final currentActivity = state.activity;
      if (state.status != RunSummaryStatus.saved ||
          currentActivity == null ||
          currentActivity.id != activity.id ||
          currentActivity.id.isEmpty) {
        return;
      }

      final result = await _repository.updateActivity(
        id: currentActivity.id,
        title: currentActivity.title,
        photoPath: path,
      );

      if (isClosed) return;

      if (result is DataStateSuccess<ActivityModel> && result.data != null) {
        emit(state.copyWith(activity: result.data));
      } else {
        emit(state.copyWith(notice: RunSummaryNotice.photoFailed));
      }
    } catch (_) {
      if (isClosed) return;

      emit(state.copyWith(notice: RunSummaryNotice.photoFailed));
    } finally {
      _photoBusy = false;
    }
  }

  void clearNotice() {
    if (state.notice == RunSummaryNotice.none) return;

    emit(state.copyWith(notice: RunSummaryNotice.none));
  }
}

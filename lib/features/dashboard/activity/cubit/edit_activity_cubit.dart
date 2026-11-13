import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:runca/config/service_locator.dart';
import 'package:runca/repository/activity_repository.dart';
import 'package:runca/repository/photo_picker_repository.dart';
import 'package:runca/utility/resource/data_state.dart';

import '../models/activity_model.dart';
import 'edit_activity_state.dart';

class EditActivityCubit extends Cubit<EditActivityState> {
  EditActivityCubit({
    required ActivityModel activity,
    ActivityRepository? repository,
    PhotoPickerRepository? photoPicker,
  }) : _activityId = activity.id,
       _repository = repository ?? serviceLocator.get<ActivityRepository>(),
       _photoPicker =
           photoPicker ?? serviceLocator.get<PhotoPickerRepository>(),
       super(
         EditActivityState(
           photoPath: activity.photoPath,
           title: activity.title,
         ),
       );

  final String _activityId;
  final ActivityRepository _repository;
  final PhotoPickerRepository _photoPicker;

  void updateTitle(String title) {
    emit(state.copyWith(title: title));
  }

  void setPhoto(String path) {
    emit(state.copyWith(photoPath: path));
  }

  Future<void> pickPhoto() async {
    try {
      final path = await _photoPicker.pickFromGallery();
      if (isClosed || path == null) return;

      setPhoto(path);
    } catch (_) {
      if (isClosed) return;

      emit(state.copyWith(notice: EditActivityNotice.pickFailed));
    }
  }

  Future<void> addPhotoRequested() async {
    if (state.photoPath != null) {
      emit(state.copyWith(notice: EditActivityNotice.photoLimit));
      return;
    }

    await pickPhoto();
  }

  void removePhoto() {
    emit(state.copyWith(clearPhoto: true));
  }

  Future<void> save() async {
    final trimmed = state.title.trim();

    if (state.status == EditActivityStatus.saving || trimmed.isEmpty) return;

    emit(state.copyWith(status: EditActivityStatus.saving));

    final result = await _repository.updateActivity(
      id: _activityId,
      title: trimmed,
      photoPath: state.photoPath,
    );

    if (isClosed) return;

    if (result is DataStateSuccess<ActivityModel>) {
      emit(state.copyWith(status: EditActivityStatus.saved));
    } else {
      emit(state.copyWith(status: EditActivityStatus.failure));
    }
  }

  /// Kembali ke keadaan awal setelah pesan gagal ditampilkan.
  void clearStatus() {
    if (state.status == EditActivityStatus.saving) return;

    emit(state.copyWith(status: EditActivityStatus.idle));
  }

  void clearNotice() {
    if (state.notice == EditActivityNotice.none) return;

    emit(state.copyWith(notice: EditActivityNotice.none));
  }
}

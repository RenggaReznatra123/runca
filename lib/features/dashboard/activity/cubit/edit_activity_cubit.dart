import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:runca/config/service_locator.dart';
import 'package:runca/repository/activity_repository.dart';
import 'package:runca/utility/resource/data_state.dart';

import '../models/activity_model.dart';
import 'edit_activity_state.dart';

class EditActivityCubit extends Cubit<EditActivityState> {
  EditActivityCubit({
    required ActivityModel activity,
    ActivityRepository? repository,
  }) : _activityId = activity.id,
       _repository = repository ?? serviceLocator.get<ActivityRepository>(),
       super(EditActivityState(photoPath: activity.photoPath));

  final String _activityId;
  final ActivityRepository _repository;

  void setPhoto(String path) {
    emit(state.copyWith(photoPath: path));
  }

  void removePhoto() {
    emit(state.copyWith(clearPhoto: true));
  }

  Future<void> save(String title) async {
    final trimmed = title.trim();

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
}

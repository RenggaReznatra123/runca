import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:runca/config/service_locator.dart';
import 'package:runca/repository/activity_repository.dart';
import 'package:runca/utility/resource/data_state.dart';

import '../models/activity_model.dart';
import 'activity_detail_state.dart';

class ActivityDetailCubit extends Cubit<ActivityDetailState> {
  ActivityDetailCubit({
    required this._activityId,
    ActivityRepository? repository,
  }) : _repository = repository ?? serviceLocator.get<ActivityRepository>(),
       super(const ActivityDetailState()) {
    load();
  }

  final String _activityId;
  final ActivityRepository _repository;

  bool _deleting = false;

  /// Muat awal dan tombol Try Again.
  Future<void> load() async {
    emit(const ActivityDetailState());

    final result = await _repository.getActivityDetail(id: _activityId);

    if (isClosed) return;

    if (result is DataStateSuccess<ActivityModel> && result.data != null) {
      emit(
        ActivityDetailState(
          status: ActivityDetailStatus.success,
          activity: result.data,
        ),
      );
    } else {
      emit(const ActivityDetailState(status: ActivityDetailStatus.failure));
    }
  }

  /// Ambil ulang tanpa loading (setelah Edit Activity). Kalau gagal,
  /// tampilan lama dibiarkan.
  Future<void> refresh() async {
    final result = await _repository.getActivityDetail(id: _activityId);

    if (isClosed) return;

    if (result is DataStateSuccess<ActivityModel> && result.data != null) {
      emit(
        ActivityDetailState(
          status: ActivityDetailStatus.success,
          activity: result.data,
        ),
      );
    }
  }

  /// Menghapus aktivitas. Mengembalikan true kalau berhasil.
  Future<bool> delete() async {
    if (_deleting) return false;

    _deleting = true;
    final result = await _repository.deleteActivity(id: _activityId);
    _deleting = false;

    return result is DataStateSuccess<bool> && result.data == true;
  }
}
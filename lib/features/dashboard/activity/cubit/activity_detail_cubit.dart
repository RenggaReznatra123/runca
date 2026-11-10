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
}

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:runca/config/service_locator.dart';
import 'package:runca/repository/place_name_repository.dart';

import '../models/activity_model.dart';
import 'activity_share_state.dart';

class ActivityShareCubit extends Cubit<ActivityShareState> {
  ActivityShareCubit({
    required ActivityModel activity,
    PlaceNameRepository? repository,
  }) : _repository = repository ?? serviceLocator.get<PlaceNameRepository>(),
       super(const ActivityShareState()) {
    _loadPlaceName(activity);
  }

  final PlaceNameRepository _repository;

  Future<void> _loadPlaceName(ActivityModel activity) async {
    if (activity.route.isEmpty) return;

    final start = activity.route.first;
    final name = await _repository.getPlaceName(
      latitude: start.latitude,
      longitude: start.longitude,
    );

    if (isClosed || name == null) return;

    emit(state.copyWith(placeName: name));
  }
}

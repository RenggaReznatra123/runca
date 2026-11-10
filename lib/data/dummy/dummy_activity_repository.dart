import 'dart:async';

import 'package:runca/data/dummy_config.dart';
import 'package:runca/features/dashboard/activity/models/activity_draft.dart';
import 'package:runca/features/dashboard/activity/models/activity_model.dart';
import 'package:runca/repository/activity_repository.dart';
import 'package:runca/utility/format_utils.dart';
import 'package:runca/utility/resource/data_state.dart';

class DummyActivityRepository implements ActivityRepository {
  // Awalnya kosong. Isinya hanya lari yang disimpan dari aplikasi
  // (disimpan di memori, hilang saat aplikasi ditutup).
  final List<ActivityModel> _activities = [];
  final StreamController<void> _changes = StreamController<void>.broadcast();
  int _nextId = 1;

  @override
  Stream<void> get changes => _changes.stream;

  @override
  Future<DataState<List<ActivityModel>>> getActivities({
    ActivityType? type,
    String? query,
  }) async {
    await DummyConfig.simulateNetwork();

    switch (DummyConfig.scenario) {
      case DummyScenario.failure:
        return DummyConfig.failure<List<ActivityModel>>('/activities');
      case DummyScenario.empty:
        return const DataStateSuccess<List<ActivityModel>>([]);
      case DummyScenario.data:
        break;
    }

    final keyword = (query ?? '').trim().toLowerCase();

    final result = _activities.where((activity) {
      if (type != null && activity.type != type) return false;
      if (keyword.isEmpty) return true;

      return activity.title.toLowerCase().contains(keyword) ||
          activity.type.label.toLowerCase().contains(keyword) ||
          AppFormat.activityDateTime(
            activity.startedAt,
          ).toLowerCase().contains(keyword);
    }).toList()..sort((a, b) => b.startedAt.compareTo(a.startedAt));

    return DataStateSuccess<List<ActivityModel>>(
      List<ActivityModel>.unmodifiable(result),
    );
  }

  @override
  Future<DataState<ActivityModel>> getActivityDetail({
    required String id,
  }) async {
    await DummyConfig.simulateNetwork();

    final index = _activities.indexWhere((activity) => activity.id == id);

    if (DummyConfig.scenario == DummyScenario.failure || index == -1) {
      return DummyConfig.failure<ActivityModel>('/activities/$id');
    }

    return DataStateSuccess<ActivityModel>(_activities[index]);
  }

  @override
  Future<DataState<ActivityModel>> saveActivity(ActivityDraft draft) async {
    await DummyConfig.simulateNetwork();

    if (DummyConfig.scenario == DummyScenario.failure) {
      return DummyConfig.failure<ActivityModel>('/activities');
    }

    final activity = ActivityModel(
      id: 'activity-${_nextId++}',
      type: draft.type,
      title: draft.title,
      startedAt: draft.startedAt,
      distanceKm: draft.distanceKm,
      durationSeconds: draft.durationSeconds,
      avgPaceSecondsPerKm: draft.avgPaceSecondsPerKm,
      calories: draft.calories,
      route: draft.route,
    );

    _activities.add(activity);
    _changes.add(null);

    return DataStateSuccess<ActivityModel>(activity);
  }

  @override
  Future<DataState<ActivityModel>> renameActivity({
    required String id,
    required String title,
  }) async {
    await DummyConfig.simulateNetwork();

    final index = _activities.indexWhere((activity) => activity.id == id);

    if (DummyConfig.scenario == DummyScenario.failure || index == -1) {
      return DummyConfig.failure<ActivityModel>('/activities/$id');
    }

    final updated = _activities[index].copyWith(title: title);
    _activities[index] = updated;
    _changes.add(null);

    return DataStateSuccess<ActivityModel>(updated);
  }
}

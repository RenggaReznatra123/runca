import 'package:runca/data/dummy_config.dart';
import 'package:runca/features/dashboard/activity/models/activity_model.dart';
import 'package:runca/repository/activity_repository.dart';
import 'package:runca/utility/format_utils.dart';
import 'package:runca/utility/resource/data_state.dart';

class DummyActivityRepository implements ActivityRepository {
  // Data dummy sesuai Figma.
  static final List<ActivityModel> _activities = [
    ActivityModel(
      id: 'activity-1',
      type: ActivityType.running,
      title: 'Lari pagi di Lapangan Simpang Lima',
      startedAt: DateTime(2026, 8, 12, 6, 42),
      distanceKm: 8.40,
      durationSeconds: 2616,
      avgPaceSecondsPerKm: 311,
      calories: 324,
    ),
    ActivityModel(
      id: 'activity-2',
      type: ActivityType.cycling,
      title: 'Bersepeda santai di Taman Kota',
      startedAt: DateTime(2026, 8, 13, 7, 15),
      distanceKm: 12.45,
      durationSeconds: 2712,
      avgPaceSecondsPerKm: 218,
      calories: 520,
    ),
    ActivityModel(
      id: 'activity-3',
      type: ActivityType.running,
      title: 'Lari pagi di Taman Kota',
      startedAt: DateTime(2026, 8, 13, 7, 15),
      distanceKm: 12.45,
      durationSeconds: 4133,
      avgPaceSecondsPerKm: 332,
      calories: 520,
    ),
  ];

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

    final result = _activities
        .where((activity) {
          if (type != null && activity.type != type) return false;
          if (keyword.isEmpty) return true;

          return activity.title.toLowerCase().contains(keyword) ||
              activity.type.label.toLowerCase().contains(keyword) ||
              AppFormat.activityDateTime(
                activity.startedAt,
              ).toLowerCase().contains(keyword);
        })
        .toList(growable: false);

    return DataStateSuccess<List<ActivityModel>>(result);
  }
}
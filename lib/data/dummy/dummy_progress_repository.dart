import 'package:runca/data/dummy/dummy_activity_stats.dart';
import 'package:runca/data/dummy_config.dart';
import 'package:runca/features/dashboard/activity/models/activity_model.dart';
import 'package:runca/features/dashboard/activity/progress/models/progress_model.dart';
import 'package:runca/repository/activity_repository.dart';
import 'package:runca/repository/progress_repository.dart';
import 'package:runca/utility/resource/data_state.dart';

/// Statistik dihitung dari lari yang tersimpan di ActivityRepository.
/// Skenario dummy (data, empty, failure) ikut ActivityRepository.
class DummyProgressRepository implements ProgressRepository {
  DummyProgressRepository(this._activities);

  final ActivityRepository _activities;

  // Awal tiap blok 4 jam di grafik.
  static const List<int> _bucketHours = [0, 4, 8, 12, 16, 20];

  // Lari lebih pendek dari ini tidak dihitung untuk Best Pace.
  static const double _minPaceDistanceKm = 0.1;

  // Week, Month, dan Year belum ada desainnya di Figma.
  static const ProgressStats _noDesignStats = ProgressStats(
    bars: [],
    distanceKm: 0,
    activityCount: 0,
    calories: 0,
    distanceChange: ProgressChange(amount: 0, isIncrease: true),
    activityChange: ProgressChange(amount: 0, isIncrease: true),
    caloriesChange: ProgressChange(amount: 0, isIncrease: true),
  );

  @override
  Stream<void> get changes => _activities.changes;

  List<ActivityModel>? _listOf(DataState<List<ActivityModel>> result) {
    if (result is DataStateSuccess<List<ActivityModel>>) {
      return result.data ?? const [];
    }

    return null;
  }

  @override
  Future<DataState<ProgressStats>> getStats({
    required ProgressPeriod period,
    required DateTime date,
    ActivityType? type,
  }) async {
    if (period != ProgressPeriod.day) {
      await DummyConfig.simulateNetwork();
      return const DataStateSuccess<ProgressStats>(_noDesignStats);
    }

    final list = _listOf(await _activities.getActivities(type: type));

    if (list == null) {
      return DummyConfig.failure<ProgressStats>('/progress/stats');
    }

    final day = DummyActivityStats.dayOf(date);
    final nextDay = DateTime(day.year, day.month, day.day + 1);
    final previousDay = DateTime(day.year, day.month, day.day - 1);

    final current = DummyActivityStats.between(list, day, nextDay);
    final previous = DummyActivityStats.between(list, previousDay, day);

    final bars = [
      for (final hour in _bucketHours)
        ProgressBar(
          label: '${hour.toString().padLeft(2, '0')}.00',
          distanceKm: current
              .where(
                (activity) =>
                    activity.startedAt.hour >= hour &&
                    activity.startedAt.hour < hour + 4,
              )
              .fold<double>(0, (sum, activity) => sum + activity.distanceKm),
        ),
    ];

    final distance = _sumDistance(current);
    final previousDistance = _sumDistance(previous);
    final calories = _sumCalories(current);
    final previousCalories = _sumCalories(previous);

    return DataStateSuccess<ProgressStats>(
      ProgressStats(
        bars: bars,
        distanceKm: distance,
        activityCount: current.length,
        calories: calories,
        distanceChange: _difference(distance, previousDistance),
        activityChange: _difference(
          current.length.toDouble(),
          previous.length.toDouble(),
        ),
        caloriesChange: _percentChange(calories, previousCalories),
      ),
    );
  }

  @override
  Future<DataState<PersonalRecords>> getPersonalRecords() async {
    final list = _listOf(await _activities.getActivities());

    if (list == null) {
      return DummyConfig.failure<PersonalRecords>('/progress/records');
    }

    var longestDistance = 0.0;
    var bestPace = 0;

    for (final activity in list) {
      if (activity.distanceKm > longestDistance) {
        longestDistance = activity.distanceKm;
      }

      final pace = activity.avgPaceSecondsPerKm;
      if (activity.distanceKm >= _minPaceDistanceKm &&
          pace > 0 &&
          (bestPace == 0 || pace < bestPace)) {
        bestPace = pace;
      }
    }

    return DataStateSuccess<PersonalRecords>(
      PersonalRecords(
        longestDistanceKm: longestDistance,
        longestStreakDays: DummyActivityStats.longestStreak(list),
        bestPaceSecondsPerKm: bestPace,
      ),
    );
  }

  double _sumDistance(List<ActivityModel> list) {
    return list.fold<double>(0, (sum, activity) => sum + activity.distanceKm);
  }

  int _sumCalories(List<ActivityModel> list) {
    return list.fold<int>(0, (sum, activity) => sum + activity.calories);
  }

  /// Selisih mutlak dengan satu desimal, naik kalau tidak lebih kecil.
  ProgressChange _difference(double current, double previous) {
    final amount = double.parse((current - previous).abs().toStringAsFixed(1));

    return ProgressChange(amount: amount, isIncrease: current >= previous);
  }

  /// Perubahan dalam persen. Kalau sebelumnya 0 dan sekarang ada, dianggap
  /// naik 100%.
  ProgressChange _percentChange(int current, int previous) {
    final double percent;

    if (previous == 0) {
      percent = current > 0 ? 100 : 0;
    } else {
      percent = ((current - previous).abs() / previous * 100).roundToDouble();
    }

    return ProgressChange(
      amount: percent,
      isPercent: true,
      isIncrease: current >= previous,
    );
  }
}

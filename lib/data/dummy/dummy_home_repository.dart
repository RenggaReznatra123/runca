import 'package:runca/data/dummy/dummy_activity_stats.dart';
import 'package:runca/data/dummy_config.dart';
import 'package:runca/features/dashboard/activity/models/activity_model.dart';
import 'package:runca/features/dashboard/home/models/home_model.dart';
import 'package:runca/repository/activity_repository.dart';
import 'package:runca/repository/home_repository.dart';
import 'package:runca/utility/resource/data_state.dart';

/// Streak dan statistik mingguan dihitung dari lari yang tersimpan di
/// ActivityRepository. Skenario dummy ikut ActivityRepository.
class DummyHomeRepository implements HomeRepository {
  DummyHomeRepository(this._activities);

  final ActivityRepository _activities;

  @override
  Stream<void> get changes => _activities.changes;

  List<ActivityModel>? _listOf(DataState<List<ActivityModel>> result) {
    if (result is DataStateSuccess<List<ActivityModel>>) {
      return result.data ?? const [];
    }

    return null;
  }

  @override
  Future<DataState<HomeOverview>> getOverview() async {
    final list = _listOf(await _activities.getActivities());

    if (list == null) return DummyConfig.failure<HomeOverview>('/home');

    return DataStateSuccess<HomeOverview>(
      _buildOverview(DateTime.now(), DummyActivityStats.currentStreak(list)),
    );
  }

  @override
  Future<DataState<WeeklyStatsData>> getWeeklyStats({
    required HomeActivityType activityType,
  }) async {
    final list = _listOf(await _activities.getActivities());

    if (list == null) {
      return DummyConfig.failure<WeeklyStatsData>('/home/weekly-stats');
    }

    final filtered = list
        .where((activity) {
          final indoor = activity.type == ActivityType.treadmill;
          return activityType == HomeActivityType.indoor ? indoor : !indoor;
        })
        .toList(growable: false);

    final today = DummyActivityStats.dayOf(DateTime.now());
    final weekStart = DateTime(
      today.year,
      today.month,
      today.day - (today.weekday - 1),
    );
    final nextWeekStart = DateTime(
      weekStart.year,
      weekStart.month,
      weekStart.day + 7,
    );
    final previousWeekStart = DateTime(
      weekStart.year,
      weekStart.month,
      weekStart.day - 7,
    );

    final current = _totals(
      DummyActivityStats.between(filtered, weekStart, nextWeekStart),
    );
    final previous = _totals(
      DummyActivityStats.between(filtered, previousWeekStart, weekStart),
    );

    final currentPace = _pace(current);
    final previousPace = _pace(previous);

    final paceChange =
        currentPace != null && previousPace != null && previousPace > 0
        ? double.parse(
            ((currentPace - previousPace).abs() / previousPace * 100)
                .toStringAsFixed(1),
          )
        : 0.0;

    return DataStateSuccess<WeeklyStatsData>(
      WeeklyStatsData(
        distanceKm: current.km,
        calories: current.kcal,
        paceSecondsPerKm: currentPace,
        durationSeconds: current.seconds,
        distanceChangeKm: double.parse(
          (current.km - previous.km).abs().toStringAsFixed(1),
        ),
        distanceIncreased: current.km >= previous.km,
        caloriesChange: (current.kcal - previous.kcal).abs(),
        caloriesIncreased: current.kcal > previous.kcal,
        paceChangePercent: paceChange,
        paceIncreased:
            currentPace == null ||
            previousPace == null ||
            currentPace >= previousPace,
        durationChangeMinutes: ((current.seconds - previous.seconds).abs() / 60)
            .round(),
        durationIncreased: current.seconds > previous.seconds,
      ),
    );
  }

  ({double km, int kcal, int seconds}) _totals(List<ActivityModel> list) {
    var km = 0.0;
    var kcal = 0;
    var seconds = 0;

    for (final activity in list) {
      km += activity.distanceKm;
      kcal += activity.calories;
      seconds += activity.durationSeconds;
    }

    return (km: km, kcal: kcal, seconds: seconds);
  }

  /// Pace rata-rata dalam detik per km. Null kalau belum ada jarak.
  int? _pace(({double km, int kcal, int seconds}) totals) {
    if (totals.km <= 0) return null;

    return (totals.seconds / totals.km).round();
  }

  HomeOverview _buildOverview(DateTime now, int streak) {
    final today = DateTime(now.year, now.month, now.day);
    final monday = today.subtract(Duration(days: today.weekday - 1));

    return HomeOverview(
      streak: streak,
      weekDays: List<WeeklyCalendarDay>.generate(7, (index) {
        final date = monday.add(Duration(days: index));
        return WeeklyCalendarDay(date: date, isToday: date == today);
      }, growable: false),
    );
  }
}

import 'package:runca/data/dummy_config.dart';
import 'package:runca/features/dashboard/home/models/home_model.dart';
import 'package:runca/repository/home_repository.dart';
import 'package:runca/utility/resource/data_state.dart';

class DummyHomeRepository implements HomeRepository {
  static const WeeklyStatsData _emptyStats = WeeklyStatsData(
    distanceKm: 0,
    calories: 0,
    paceSecondsPerKm: null,
    durationSeconds: 0,
    distanceChangeKm: 0,
    distanceIncreased: true,
    caloriesChange: 0,
    caloriesIncreased: false,
    paceChangePercent: 0,
    paceIncreased: true,
    durationChangeMinutes: 0,
    durationIncreased: false,
  );

  @override
  Future<DataState<HomeOverview>> getOverview() async {
    await DummyConfig.simulateNetwork();

    switch (DummyConfig.scenario) {
      case DummyScenario.failure:
        return DummyConfig.failure<HomeOverview>('/home');
      case DummyScenario.empty:
      case DummyScenario.data:
        return DataStateSuccess<HomeOverview>(_buildOverview(DateTime.now()));
    }
  }

  @override
  Future<DataState<WeeklyStatsData>> getWeeklyStats({
    required HomeActivityType activityType,
  }) async {
    await DummyConfig.simulateNetwork();

    switch (DummyConfig.scenario) {
      case DummyScenario.failure:
        return DummyConfig.failure<WeeklyStatsData>('/home/weekly-stats');
      case DummyScenario.empty:
      case DummyScenario.data:
        return const DataStateSuccess<WeeklyStatsData>(_emptyStats);
    }
  }

  HomeOverview _buildOverview(DateTime now) {
    final today = DateTime(now.year, now.month, now.day);
    final monday = today.subtract(Duration(days: today.weekday - 1));
    return HomeOverview(
      streak: 0,
      weekDays: List<WeeklyCalendarDay>.generate(
        7,
        (index) {
          final date = monday.add(Duration(days: index));
          return WeeklyCalendarDay(
            date: date,
            isToday: date == today,
          );
        },
        growable: false,
      ),
    );
  }
}

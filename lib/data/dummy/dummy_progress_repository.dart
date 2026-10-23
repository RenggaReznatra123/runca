import 'package:runca/data/dummy_config.dart';
import 'package:runca/features/dashboard/activity/models/activity_model.dart';
import 'package:runca/features/dashboard/activity/progress/models/progress_model.dart';
import 'package:runca/repository/progress_repository.dart';
import 'package:runca/utility/resource/data_state.dart';

class DummyProgressRepository implements ProgressRepository {
  // Data dummy sesuai Figma (tampilan Day). Jumlah batang = 32.6 km.
  static const ProgressStats _dayStats = ProgressStats(
    bars: [
      ProgressBar(label: '00.00', distanceKm: 1.8),
      ProgressBar(label: '04.00', distanceKm: 4.1),
      ProgressBar(label: '08.00', distanceKm: 6.9),
      ProgressBar(label: '12.00', distanceKm: 8.8),
      ProgressBar(label: '16.00', distanceKm: 11.0),
      ProgressBar(label: '20.00', distanceKm: 0),
    ],
    distanceKm: 32.6,
    activityCount: 5,
    calories: 1280,
    distanceChange: ProgressChange(amount: 2, isIncrease: true),
    activityChange: ProgressChange(amount: 2, isIncrease: true),
    caloriesChange: ProgressChange(
      amount: 12,
      isPercent: true,
      isIncrease: false,
    ),
  );

  // Tidak ada aktivitas pada periode itu.
  static const ProgressStats _emptyDayStats = ProgressStats(
    bars: [
      ProgressBar(label: '00.00', distanceKm: 0),
      ProgressBar(label: '04.00', distanceKm: 0),
      ProgressBar(label: '08.00', distanceKm: 0),
      ProgressBar(label: '12.00', distanceKm: 0),
      ProgressBar(label: '16.00', distanceKm: 0),
      ProgressBar(label: '20.00', distanceKm: 0),
    ],
    distanceKm: 0,
    activityCount: 0,
    calories: 0,
    distanceChange: ProgressChange(amount: 0, isIncrease: true),
    activityChange: ProgressChange(amount: 0, isIncrease: true),
    caloriesChange: ProgressChange(amount: 0, isIncrease: true),
  );

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

  static const PersonalRecords _records = PersonalRecords(
    longestDistanceKm: 20.4,
    longestStreakDays: 12,
    bestPaceSecondsPerKm: 255,
  );

  static const PersonalRecords _emptyRecords = PersonalRecords(
    longestDistanceKm: 0,
    longestStreakDays: 0,
    bestPaceSecondsPerKm: 0,
  );

  @override
  Future<DataState<ProgressStats>> getStats({
    required ProgressPeriod period,
    required DateTime date,
    ActivityType? type,
  }) async {
    await DummyConfig.simulateNetwork();

    if (DummyConfig.scenario == DummyScenario.failure) {
      return DummyConfig.failure<ProgressStats>('/progress/stats');
    }

    if (period != ProgressPeriod.day) {
      return const DataStateSuccess<ProgressStats>(_noDesignStats);
    }

    if (DummyConfig.scenario == DummyScenario.empty) {
      return const DataStateSuccess<ProgressStats>(_emptyDayStats);
    }

    return const DataStateSuccess<ProgressStats>(_dayStats);
  }

  @override
  Future<DataState<PersonalRecords>> getPersonalRecords() async {
    await DummyConfig.simulateNetwork();

    switch (DummyConfig.scenario) {
      case DummyScenario.failure:
        return DummyConfig.failure<PersonalRecords>('/progress/records');
      case DummyScenario.empty:
        return const DataStateSuccess<PersonalRecords>(_emptyRecords);
      case DummyScenario.data:
        return const DataStateSuccess<PersonalRecords>(_records);
    }
  }
}
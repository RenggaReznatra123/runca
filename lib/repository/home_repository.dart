import 'package:runca/features/dashboard/home/models/home_model.dart';
import 'package:runca/utility/resource/data_state.dart';

abstract class HomeRepository {
  Future<DataState<HomeOverview>> getOverview();

  Future<DataState<WeeklyStatsData>> getWeeklyStats({
    required HomeActivityType activityType,
  });
}

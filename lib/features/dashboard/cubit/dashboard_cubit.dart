import 'package:flutter_bloc/flutter_bloc.dart';

import '../activity/cubit/activity_state.dart';
import 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit() : super(const DashboardState());

  void selectTab(DashboardTab tab) {
    emit(state.copyWith(selectedTab: tab));
  }

  /// Pindah ke tab Activity di navbar dan buka sub-tab yang diminta.
  void openActivity(ActivityTab tab) {
    emit(
      state.copyWith(
        selectedTab: DashboardTab.activity,
        activityTab: tab,
        activityTabRequest: state.activityTabRequest + 1,
      ),
    );
  }
}

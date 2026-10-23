import '../activity/cubit/activity_state.dart';

enum DashboardTab { home, challenge, run, activity, profile }

class DashboardState {
  const DashboardState({
    this.selectedTab = DashboardTab.home,
    this.activityTab = ActivityTab.activities,
    this.activityTabRequest = 0,
  });

  final DashboardTab selectedTab;

  /// Sub-tab yang diminta untuk halaman Activity (Progress atau Activities).
  final ActivityTab activityTab;

  /// Bertambah setiap kali ada permintaan buka sub-tab, supaya permintaan
  /// yang sama dua kali berturut-turut tetap terdeteksi.
  final int activityTabRequest;

  DashboardState copyWith({
    DashboardTab? selectedTab,
    ActivityTab? activityTab,
    int? activityTabRequest,
  }) {
    return DashboardState(
      selectedTab: selectedTab ?? this.selectedTab,
      activityTab: activityTab ?? this.activityTab,
      activityTabRequest: activityTabRequest ?? this.activityTabRequest,
    );
  }
}

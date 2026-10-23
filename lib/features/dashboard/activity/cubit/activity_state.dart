import '../models/activity_model.dart';

enum ActivityTab { progress, activities }

enum ActivityStatus { loading, success, failure }

enum ActivityFilter {
  all('All', null),
  running('Running', ActivityType.running),
  treadmill('Treadmill', ActivityType.treadmill),
  cycling('Cycling', ActivityType.cycling);

  const ActivityFilter(this.label, this.type);

  final String label;

  /// Jenis aktivitas yang dikirim ke repository. Null berarti semua.
  final ActivityType? type;
}

class ActivityState {
  const ActivityState({
    // Sementara Activities dulu karena Progress belum dikerjakan.
    // Kalau Progress sudah jadi, ganti ke ActivityTab.progress (sesuai Figma).
    this.selectedTab = ActivityTab.activities,
    this.status = ActivityStatus.loading,
    this.selectedFilter = ActivityFilter.all,
    this.searchQuery = '',
    this.activities = const [],
  });

  final ActivityTab selectedTab;
  final ActivityStatus status;
  final ActivityFilter selectedFilter;
  final String searchQuery;

  /// Hasil dari repository, sudah terfilter dan tercari.
  final List<ActivityModel> activities;

  /// True kalau filter chip atau pencarian sedang dipakai.
  bool get hasActiveFilter =>
      selectedFilter != ActivityFilter.all || searchQuery.trim().isNotEmpty;

  ActivityState copyWith({
    ActivityTab? selectedTab,
    ActivityStatus? status,
    ActivityFilter? selectedFilter,
    String? searchQuery,
    List<ActivityModel>? activities,
  }) {
    return ActivityState(
      selectedTab: selectedTab ?? this.selectedTab,
      status: status ?? this.status,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      searchQuery: searchQuery ?? this.searchQuery,
      activities: activities ?? this.activities,
    );
  }
}
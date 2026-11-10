import '../models/activity_model.dart';

enum ActivityDetailStatus { loading, success, failure }

class ActivityDetailState {
  const ActivityDetailState({
    this.status = ActivityDetailStatus.loading,
    this.activity,
  });

  final ActivityDetailStatus status;
  final ActivityModel? activity;

  ActivityDetailState copyWith({
    ActivityDetailStatus? status,
    ActivityModel? activity,
  }) {
    return ActivityDetailState(
      status: status ?? this.status,
      activity: activity ?? this.activity,
    );
  }
}

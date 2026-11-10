import 'package:runca/features/dashboard/activity/models/activity_model.dart';

enum RunSummaryStatus { saving, saved, failure }

class RunSummaryState {
  const RunSummaryState({this.status = RunSummaryStatus.saving, this.activity});

  final RunSummaryStatus status;

  /// Aktivitas yang sudah tersimpan. Null selama menyimpan atau gagal.
  final ActivityModel? activity;

  RunSummaryState copyWith({
    RunSummaryStatus? status,
    ActivityModel? activity,
  }) {
    return RunSummaryState(
      status: status ?? this.status,
      activity: activity ?? this.activity,
    );
  }
}

import 'package:runca/features/dashboard/activity/models/activity_model.dart';

enum RunSummaryStatus { saving, saved, failure }

enum RunSummaryNotice { none, photoFailed }

class RunSummaryState {
  const RunSummaryState({
    this.status = RunSummaryStatus.saving,
    this.activity,
    this.notice = RunSummaryNotice.none,
  });

  final RunSummaryStatus status;

  /// Aktivitas yang sudah tersimpan. Null selama menyimpan atau gagal.
  final ActivityModel? activity;
  final RunSummaryNotice notice;

  RunSummaryState copyWith({
    RunSummaryStatus? status,
    ActivityModel? activity,
    RunSummaryNotice? notice,
  }) {
    return RunSummaryState(
      status: status ?? this.status,
      activity: activity ?? this.activity,
      notice: notice ?? this.notice,
    );
  }
}

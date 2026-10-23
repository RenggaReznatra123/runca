import '../../cubit/activity_state.dart';
import '../models/progress_model.dart';

enum ProgressStatus { loading, success, failure }

class ProgressState {
  const ProgressState({
    required this.selectedDate,
    this.status = ProgressStatus.loading,
    this.selectedPeriod = ProgressPeriod.day,
    this.selectedFilter = ActivityFilter.all,
    this.stats,
    this.records,
  });

  final DateTime selectedDate;
  final ProgressStatus status;
  final ProgressPeriod selectedPeriod;
  final ActivityFilter selectedFilter;
  final ProgressStats? stats;
  final PersonalRecords? records;

  ProgressState copyWith({
    DateTime? selectedDate,
    ProgressStatus? status,
    ProgressPeriod? selectedPeriod,
    ActivityFilter? selectedFilter,
    ProgressStats? stats,
    PersonalRecords? records,
  }) {
    return ProgressState(
      selectedDate: selectedDate ?? this.selectedDate,
      status: status ?? this.status,
      selectedPeriod: selectedPeriod ?? this.selectedPeriod,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      stats: stats ?? this.stats,
      records: records ?? this.records,
    );
  }
}
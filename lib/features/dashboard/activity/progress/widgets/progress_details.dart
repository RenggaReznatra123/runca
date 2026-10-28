import 'package:flutter/material.dart';
import 'package:runca/features/dashboard/activity/progress/cubit/progress_state.dart';
import 'package:runca/features/dashboard/activity/progress/models/progress_model.dart';
import 'package:runca/features/dashboard/activity/progress/widgets/personal_records_list.dart';
import 'package:runca/features/dashboard/activity/progress/widgets/progress_bar_chart.dart';
import 'package:runca/features/dashboard/activity/progress/widgets/progress_date_navigator.dart';
import 'package:runca/features/dashboard/activity/progress/widgets/progress_error_view.dart';
import 'package:runca/features/dashboard/activity/progress/widgets/progress_loading_block.dart';
import 'package:runca/features/dashboard/activity/progress/widgets/progress_period_placeholder.dart';
import 'package:runca/features/dashboard/activity/progress/widgets/progress_summary_card.dart';
import 'package:runca/features/dashboard/activity/progress/widgets/progress_total_value.dart';
import 'package:runca/ui/color.dart';
import 'package:runca/ui/typography.dart';
import 'package:runca/utility/format_utils.dart';

class ProgressDetails extends StatelessWidget {
  const ProgressDetails({
    required this.state,
    required this.onRetry,
    required this.onPreviousDate,
    required this.onNextDate,
    super.key,
  });

  static const EdgeInsets _pagePadding = EdgeInsets.symmetric(horizontal: 20);

  final ProgressState state;
  final VoidCallback onRetry;
  final VoidCallback onPreviousDate;
  final VoidCallback onNextDate;

  static String _comparisonLabel(ProgressPeriod period) {
    switch (period) {
      case ProgressPeriod.day:
        return 'vs last day';
      case ProgressPeriod.week:
        return 'vs last week';
      case ProgressPeriod.month:
        return 'vs last month';
      case ProgressPeriod.year:
        return 'vs last year';
    }
  }

  @override
  Widget build(BuildContext context) {
    final records = state.records;
    final showRecords =
        records != null && state.status != ProgressStatus.failure;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ..._buildStats(),
        if (showRecords) ...[
          const SizedBox(height: 26),
          Padding(
            padding: _pagePadding,
            child: Text(
              'Personal Records',
              style: AppTypography.titleLarge(
                color: AppPalette.textNeutralPrimary,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: _pagePadding,
            child: PersonalRecordsList(records: records),
          ),
        ],
      ],
    );
  }

  List<Widget> _buildStats() {
    if (state.selectedPeriod != ProgressPeriod.day) {
      return const [ProgressPeriodPlaceholder()];
    }

    if (state.status == ProgressStatus.failure) {
      return [
        Padding(
          padding: const EdgeInsets.only(top: 24),
          child: ProgressErrorView(onRetry: onRetry),
        ),
      ];
    }

    final stats = state.stats;
    if (state.status == ProgressStatus.loading || stats == null) {
      return const [ProgressLoadingBlock()];
    }

    return _buildDayStats(stats);
  }

  List<Widget> _buildDayStats(ProgressStats stats) {
    final comparison = _comparisonLabel(state.selectedPeriod);

    return [
      Padding(
        padding: _pagePadding,
        child: ProgressDateNavigator(
          title: 'Total Distance',
          date: AppFormat.fullDate(state.selectedDate),
          onPrevious: onPreviousDate,
          onNext: onNextDate,
        ),
      ),
      const SizedBox(height: 6),
      Padding(
        padding: _pagePadding,
        child: ProgressTotalValue(
          value: AppFormat.distanceValue(stats.distanceKm),
          unit: 'km',
        ),
      ),
      const SizedBox(height: 20),
      Padding(
        padding: _pagePadding,
        child: ProgressBarChart(bars: stats.bars),
      ),
      const SizedBox(height: 16),
      SizedBox(
        height: 108,
        child: ListView(
          scrollDirection: Axis.horizontal,
          padding: _pagePadding,
          children: [
            ProgressSummaryCard(
              icon: Icons.route_outlined,
              iconColor: AppPalette.iconPrimary,
              title: 'Total Distance',
              value: AppFormat.distanceValue(stats.distanceKm),
              unit: 'km',
              change: AppFormat.change(
                stats.distanceChange.amount,
                isPercent: stats.distanceChange.isPercent,
              ),
              isIncrease: stats.distanceChange.isIncrease,
              comparisonLabel: comparison,
              selected: true,
            ),
            const SizedBox(width: 8),
            ProgressSummaryCard(
              icon: Icons.directions_run_rounded,
              iconColor: AppPalette.iconPrimary,
              title: 'Activities',
              value: AppFormat.integer(stats.activityCount),
              change: AppFormat.change(
                stats.activityChange.amount,
                isPercent: stats.activityChange.isPercent,
              ),
              isIncrease: stats.activityChange.isIncrease,
              comparisonLabel: comparison,
            ),
            const SizedBox(width: 8),
            ProgressSummaryCard(
              icon: Icons.local_fire_department_outlined,
              iconColor: AppPalette.iconSecondary,
              title: 'Calories',
              value: AppFormat.thousands(stats.calories),
              unit: 'kcal',
              change: AppFormat.change(
                stats.caloriesChange.amount,
                isPercent: stats.caloriesChange.isPercent,
              ),
              isIncrease: stats.caloriesChange.isIncrease,
              comparisonLabel: comparison,
            ),
          ],
        ),
      ),
    ];
  }
}

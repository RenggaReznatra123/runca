import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:runca/ui/color.dart';
import 'package:runca/ui/typography.dart';
import 'package:runca/utility/format_utils.dart';

import 'cubit/progress_cubit.dart';
import 'cubit/progress_state.dart';
import 'models/progress_model.dart';
import 'widgets/personal_record_item.dart';
import 'widgets/progress_bar_chart.dart';
import 'widgets/progress_date_navigator.dart';
import 'widgets/progress_error_view.dart';
import 'widgets/progress_period_selector.dart';
import 'widgets/progress_stats_header.dart';
import 'widgets/progress_summary_card.dart';

class ProgressTab extends StatelessWidget {
  const ProgressTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProgressCubit(),
      child: const _ProgressView(),
    );
  }
}

class _ProgressView extends StatelessWidget {
  const _ProgressView();

  static const EdgeInsets _pagePadding = EdgeInsets.symmetric(horizontal: 20);

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
    return BlocBuilder<ProgressCubit, ProgressState>(
      builder: (context, state) {
        final cubit = context.read<ProgressCubit>();
        final records = state.records;
        final showRecords =
            records != null && state.status != ProgressStatus.failure;

        return SingleChildScrollView(
          key: const PageStorageKey<String>('progress_scroll'),
          physics: const ClampingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          padding: const EdgeInsets.only(bottom: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: _pagePadding,
                child: ProgressStatsHeader(
                  selectedFilter: state.selectedFilter,
                  onFilterChanged: cubit.selectFilter,
                ),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: _pagePadding,
                child: ProgressPeriodSelector(
                  selectedPeriod: state.selectedPeriod,
                  onChanged: cubit.selectPeriod,
                ),
              ),
              const SizedBox(height: 24),
              ..._buildStats(state, cubit),
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
                  child: _PersonalRecordList(records: records),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  List<Widget> _buildStats(ProgressState state, ProgressCubit cubit) {
    // Week, Month, dan Year belum ada desainnya di Figma.
    if (state.selectedPeriod != ProgressPeriod.day) {
      return const [_PeriodPlaceholder()];
    }

    if (state.status == ProgressStatus.failure) {
      return [
        Padding(
          padding: const EdgeInsets.only(top: 24),
          child: ProgressErrorView(onRetry: cubit.loadProgress),
        ),
      ];
    }

    final stats = state.stats;

    if (state.status == ProgressStatus.loading || stats == null) {
      return const [_LoadingBlock()];
    }

    return _buildDayStats(state, stats, cubit);
  }

  List<Widget> _buildDayStats(
    ProgressState state,
    ProgressStats stats,
    ProgressCubit cubit,
  ) {
    final comparison = _comparisonLabel(state.selectedPeriod);

    return [
      Padding(
        padding: _pagePadding,
        child: ProgressDateNavigator(
          title: 'Total Distance',
          date: AppFormat.fullDate(state.selectedDate),
          onPrevious: cubit.previousDate,
          onNext: cubit.nextDate,
        ),
      ),
      const SizedBox(height: 6),
      Padding(
        padding: _pagePadding,
        child: _TotalValue(
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
              value: '${stats.activityCount}',
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

class _TotalValue extends StatelessWidget {
  const _TotalValue({required this.value, required this.unit});

  final String value;
  final String unit;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: value,
            style: AppTypography.displayLarge(
              color: AppPalette.textNeutralPrimary,
            ).copyWith(height: 1.2),
          ),
          TextSpan(
            text: ' $unit',
            style: AppTypography.displayLarge(
              color: AppPalette.textNeutralSecondary,
            ).copyWith(height: 1.2, fontWeight: AppTypography.semiBold),
          ),
        ],
      ),
      maxLines: 1,
    );
  }
}

class _PersonalRecordList extends StatelessWidget {
  const _PersonalRecordList({required this.records});

  final PersonalRecords records;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PersonalRecordItem(
          key: const ValueKey('longest_distance'),
          icon: Icons.route_outlined,
          iconColor: AppPalette.iconPrimary,
          label: 'Longest Distance',
          value: AppFormat.distanceValue(records.longestDistanceKm),
          unit: 'km',
        ),
        const SizedBox(height: 10),
        PersonalRecordItem(
          key: const ValueKey('longest_streak'),
          icon: Icons.local_fire_department_rounded,
          iconColor: AppPalette.iconSecondary,
          label: 'Longest Streak',
          value: '${records.longestStreakDays}',
          unit: records.longestStreakDays == 1 ? 'day' : 'days',
        ),
        const SizedBox(height: 10),
        PersonalRecordItem(
          key: const ValueKey('best_pace'),
          icon: Icons.bolt_outlined,
          iconColor: AppPalette.iconPrimary,
          label: 'Best Pace',
          value: AppFormat.pace(records.bestPaceSecondsPerKm),
          unit: '/km',
        ),
      ],
    );
  }
}

class _LoadingBlock extends StatelessWidget {
  const _LoadingBlock();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 240,
      child: Center(
        child: CircularProgressIndicator(color: AppPalette.bgFillPrimary),
      ),
    );
  }
}

/// Sementara untuk Week, Month, Year karena belum ada desain di Figma.
class _PeriodPlaceholder extends StatelessWidget {
  const _PeriodPlaceholder();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: Center(
        child: Text(
          'Design for this period is not available yet.',
          textAlign: TextAlign.center,
          style: AppTypography.bodyMedium(
            color: AppPalette.textNeutralSecondary,
          ),
        ),
      ),
    );
  }
}

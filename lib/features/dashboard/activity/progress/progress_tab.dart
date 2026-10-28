import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/progress_cubit.dart';
import 'cubit/progress_state.dart';
import 'widgets/progress_details.dart';
import 'widgets/progress_period_selector.dart';
import 'widgets/progress_stats_header.dart';

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

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProgressCubit, ProgressState>(
      builder: (context, state) {
        final cubit = context.read<ProgressCubit>();

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
              ProgressDetails(
                state: state,
                onRetry: cubit.loadProgress,
                onPreviousDate: cubit.previousDate,
                onNextDate: cubit.nextDate,
              ),
            ],
          ),
        );
      },
    );
  }
}

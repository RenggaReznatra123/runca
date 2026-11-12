import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:runca/features/dashboard/activity/activity_detail_screen.dart';
import 'package:runca/features/dashboard/activity/models/activity_draft.dart';
import 'package:runca/features/dashboard/activity/models/activity_model.dart';
import 'package:runca/features/dashboard/activity/widgets/activity_state_view.dart';
import 'package:runca/features/dashboard/treadmill/widgets/treadmill_summary_add_card.dart';
import 'package:runca/features/dashboard/treadmill/widgets/treadmill_summary_stats.dart';
import 'package:runca/ui/color.dart';
import 'package:runca/utility/snackbar_extension.dart';

import 'cubit/run_summary_cubit.dart';
import 'cubit/run_summary_state.dart';
import 'widgets/run_summary_actions.dart';
import 'widgets/run_summary_header.dart';
import 'widgets/run_summary_map.dart';
import 'widgets/run_summary_stats.dart';
import 'widgets/run_summary_title.dart';

/// Layar "Run Complete!" / "Treadmill Complete!": menyimpan aktivitas lalu
/// menampilkan ringkasannya.
class RunSummaryScreen extends StatelessWidget {
  const RunSummaryScreen({super.key, required this.draft});

  final ActivityDraft draft;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RunSummaryCubit(draft: draft),
      child: const _RunSummaryView(),
    );
  }
}

class _RunSummaryView extends StatelessWidget {
  const _RunSummaryView();

  void _showUnavailable(BuildContext context, String page) {
    context.showUnavailableSnackbar(page, duration: const Duration(seconds: 2));
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<RunSummaryCubit>();

    return Scaffold(
      backgroundColor: AppPalette.bg,
      body: SafeArea(
        child: BlocBuilder<RunSummaryCubit, RunSummaryState>(
          builder: (context, state) {
            final activity = state.activity;

            if (state.status == RunSummaryStatus.saving) {
              return const Center(
                child: CircularProgressIndicator(
                  color: AppPalette.bgFillPrimary,
                ),
              );
            }

            if (state.status == RunSummaryStatus.failure || activity == null) {
              return Center(child: ActivityErrorView(onRetry: cubit.save));
            }

            final isTreadmill = activity.type == ActivityType.treadmill;

            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RunSummaryHeader(
                          startedAt: activity.startedAt,
                          title: isTreadmill
                              ? 'Treadmill Complete!'
                              : 'Run Complete!',
                        ),
                        const SizedBox(height: 24),
                        RunSummaryTitle(
                          title: activity.title,
                          onRename: cubit.rename,
                        ),
                        const SizedBox(height: 24),
                        if (isTreadmill) ...[
                          TreadmillSummaryStats(
                            durationSeconds: activity.durationSeconds,
                            steps: activity.steps ?? 0,
                          ),
                          const SizedBox(height: 32),
                          Row(
                            children: [
                              Expanded(
                                child: TreadmillSummaryAddCard(
                                  label: 'Calories',
                                  onTap: () =>
                                      _showUnavailable(context, 'Calories'),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: TreadmillSummaryAddCard(
                                  label: 'Distance',
                                  onTap: () =>
                                      _showUnavailable(context, 'Distance'),
                                ),
                              ),
                            ],
                          ),
                        ] else ...[
                          RunSummaryStats(
                            distanceKm: activity.distanceKm,
                            durationSeconds: activity.durationSeconds,
                            paceSecondsPerKm: activity.avgPaceSecondsPerKm,
                            calories: activity.calories,
                          ),
                          const SizedBox(height: 24),
                          RunSummaryMap(
                            route: activity.route,
                            onCameraTap: () =>
                                _showUnavailable(context, 'Photo'),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                RunSummaryActions(
                  onBackToHome: () => Navigator.of(context).pop(),
                  onViewDetails: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) =>
                            ActivityDetailScreen(activityId: activity.id),
                      ),
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:runca/features/dashboard/cubit/dashboard_cubit.dart';
import 'package:runca/features/dashboard/cubit/dashboard_state.dart';
import 'package:runca/ui/color.dart';
import 'package:runca/ui/shared_view/empty_view.dart';

import '../cubit/activity_cubit.dart';
import '../cubit/activity_state.dart';
import 'activity_error_banner.dart';
import 'activity_filter.dart';
import 'activity_item.dart';
import 'activity_search_field.dart';
import 'activity_state_view.dart';

class ActivityListTab extends StatelessWidget {
  const ActivityListTab({required this.state, super.key});

  final ActivityState state;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ActivityCubit>();

    return CustomScrollView(
      key: const PageStorageKey<String>('activity_list_scroll'),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      physics: const ClampingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ActivitySearchField(onChanged: cubit.search),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 24)),
        SliverToBoxAdapter(
          child: ActivityFilterChips(
            selectedFilter: state.selectedFilter,
            onChanged: cubit.selectFilter,
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ..._buildContent(context, cubit),
      ],
    );
  }

  List<Widget> _buildContent(BuildContext context, ActivityCubit cubit) {
    if (state.status == ActivityStatus.loading) {
      return const [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Center(
            child: CircularProgressIndicator(color: AppPalette.bgFillPrimary),
          ),
        ),
      ];
    }

    if (state.status == ActivityStatus.failure) {
      return [
        const SliverToBoxAdapter(
          child: ActivityErrorBanner(
            message: 'Activity history is temporarily unavailable.',
          ),
        ),
        SliverFillRemaining(
          hasScrollBody: false,
          child: Padding(
            padding: const EdgeInsets.only(top: 60),
            child: Align(
              alignment: Alignment.topCenter,
              child: ActivityErrorView(onRetry: cubit.loadActivities),
            ),
          ),
        ),
      ];
    }

    final activities = state.activities;

    if (activities.isEmpty) {
      if (state.hasActiveFilter) {
        return const [
          SliverFillRemaining(
            hasScrollBody: false,
            child: EmptyView(message: 'No activities found.'),
          ),
        ];
      }

      return [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Padding(
            padding: const EdgeInsets.only(top: 120),
            child: Align(
              alignment: Alignment.topCenter,
              child: ActivityEmptyView(
                onStartActivity: () {
                  context.read<DashboardCubit>().selectTab(DashboardTab.run);
                },
              ),
            ),
          ),
        ),
      ];
    }

    return [
      SliverPadding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        sliver: SliverList.separated(
          itemCount: activities.length,
          separatorBuilder: (_, _) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final activity = activities[index];

            return ActivityItem(key: ValueKey(activity.id), activity: activity);
          },
        ),
      ),
    ];
  }
}

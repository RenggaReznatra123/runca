import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:runca/features/dashboard/cubit/dashboard_cubit.dart';
import 'package:runca/features/dashboard/cubit/dashboard_state.dart';
import 'package:runca/features/dashboard/home/notifications/notifications_screen.dart';
import 'package:runca/ui/color.dart';
import 'package:runca/ui/shared_view/empty_view.dart';

import 'cubit/activity_cubit.dart';
import 'cubit/activity_state.dart';
import 'progress/progress_tab.dart';
import 'widgets/activity_error_banner.dart';
import 'widgets/activity_filter.dart';
import 'widgets/activity_header.dart';
import 'widgets/activity_item.dart';
import 'widgets/activity_search_field.dart';
import 'widgets/activity_state_view.dart';
import 'widgets/activity_tabs.dart';

class ActivityScreen extends StatelessWidget {
  const ActivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ActivityCubit(),
      child: const _ActivityView(),
    );
  }
}

class _ActivityView extends StatelessWidget {
  const _ActivityView();

  @override
  Widget build(BuildContext context) {
    return BlocListener<DashboardCubit, DashboardState>(
      listenWhen: (previous, current) =>
          previous.activityTabRequest != current.activityTabRequest,
      listener: (context, state) {
        context.read<ActivityCubit>().selectTab(state.activityTab);
      },
      child: Scaffold(
        backgroundColor: AppPalette.bg,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              ActivityHeader(
                onNotificationTap: () {
                  final dashboardCubit = context.read<DashboardCubit>();

                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => BlocProvider.value(
                        value: dashboardCubit,
                        child: const NotificationsScreen(),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              BlocSelector<ActivityCubit, ActivityState, ActivityTab>(
                selector: (state) => state.selectedTab,
                builder: (context, selectedTab) {
                  return ActivityTabs(
                    selectedTab: selectedTab,
                    onChanged: context.read<ActivityCubit>().selectTab,
                  );
                },
              ),
              const SizedBox(height: 24),
              Expanded(
                child: BlocBuilder<ActivityCubit, ActivityState>(
                  builder: (context, state) {
                    return IndexedStack(
                      index: state.selectedTab.index,
                      children: [
                        const ProgressTab(),
                        _ActivitiesTab(state: state),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActivitiesTab extends StatelessWidget {
  const _ActivitiesTab({required this.state});

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
    // 1. Sedang memuat.
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

    // 2. Gagal memuat data.
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
      // 3. Filter atau pencarian tidak menemukan hasil.
      if (state.hasActiveFilter) {
        return const [
          SliverFillRemaining(
            hasScrollBody: false,
            child: EmptyView(message: 'No activities found.'),
          ),
        ];
      }

      // 4. Belum ada aktivitas sama sekali.
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

    // 5. Daftar aktivitas.
    return [
      SliverPadding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        sliver: SliverList.separated(
          itemCount: activities.length,
          separatorBuilder: (_, _) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final activity = activities[index];

            return ActivityItem(
              key: ValueKey(activity.id),
              activity: activity,
            );
          },
        ),
      ),
    ];
  }
}
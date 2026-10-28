import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:runca/features/dashboard/cubit/dashboard_cubit.dart';
import 'package:runca/features/dashboard/cubit/dashboard_state.dart';
import 'package:runca/features/dashboard/home/notifications/notifications_screen.dart';
import 'package:runca/ui/color.dart';

import 'cubit/activity_cubit.dart';
import 'cubit/activity_state.dart';
import 'progress/progress_tab.dart';
import 'widgets/activity_header.dart';
import 'widgets/activity_list_tab.dart';
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
                        ActivityListTab(state: state),
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

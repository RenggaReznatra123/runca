import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:runca/features/dashboard/activity/cubit/activity_cubit.dart';
import 'package:runca/features/dashboard/activity/cubit/activity_state.dart';
import 'package:runca/features/dashboard/activity/models/activity_model.dart';
import 'package:runca/features/dashboard/cubit/dashboard_cubit.dart';

import 'home_section_divider.dart';
import 'home_section_header.dart';
import 'last_activity_card.dart';

/// Bagian "Last Activity". Tidak tampil kalau belum ada aktivitas.
class HomeLastActivitySection extends StatelessWidget {
  const HomeLastActivitySection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ActivityCubit, ActivityState>(
      builder: (context, state) {
        if (state.status != ActivityStatus.success ||
            state.activities.isEmpty) {
          return const SizedBox.shrink();
        }

        // Aktivitas dengan waktu mulai paling baru.
        final ActivityModel latest = state.activities.reduce(
          (a, b) => a.startedAt.isAfter(b.startedAt) ? a : b,
        );

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const HomeSectionDivider(),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: HomeSectionHeader(
                title: 'Last Activity',
                actionLabel: 'View All',
                onActionTap: () => context.read<DashboardCubit>().openActivity(
                  ActivityTab.activities,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              child: LastActivityCard(activity: latest),
            ),
          ],
        );
      },
    );
  }
}

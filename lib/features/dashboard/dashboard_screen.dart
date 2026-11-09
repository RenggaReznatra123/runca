import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:runca/ui/color.dart';

import 'activity/activity_screen.dart';
import 'challenge/challenge_screen.dart';
import 'cubit/dashboard_cubit.dart';
import 'cubit/dashboard_state.dart';
import 'home/home_screen.dart';
import 'profile/profile_screen.dart';
import 'run/run_screen.dart';
import 'widgets/dashboard_bottom_navigation.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DashboardCubit(),
      child: const _DashboardView(),
    );
  }
}

class _DashboardView extends StatelessWidget {
  const _DashboardView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardCubit, DashboardState>(
      builder: (context, state) {
        final selectedIndex = state.selectedTab.index;

        return Scaffold(
          backgroundColor: AppPalette.bg,
          body: IndexedStack(
            index: selectedIndex,
            children: const [
              HomeScreen(),
              ChallengeScreen(),
              ActivityScreen(),
              ProfileScreen(),
            ],
          ),
          bottomNavigationBar: DashboardBottomNavigation(
            selectedTab: state.selectedTab,
            onSelect: (tab) => _select(context, tab),
            onRun: () => _openRun(context),
          ),
        );
      },
    );
  }

  void _select(BuildContext context, DashboardTab tab) {
    context.read<DashboardCubit>().selectTab(tab);
  }

  /// Layar lari dibuka di atas dashboard (tanpa navbar), bukan sebagai tab.
  void _openRun(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const RunScreen()));
  }
}

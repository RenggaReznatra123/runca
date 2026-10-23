import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:runca/ui/color.dart';

import 'activity/activity_screen.dart';
import 'challenge/challenge_screen.dart';
import 'cubit/dashboard_cubit.dart';
import 'cubit/dashboard_state.dart';
import 'home/home_screen.dart';
import 'profile/profile_screen.dart';

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
              _RunScreen(),
              ActivityScreen(),
              ProfileScreen(),
            ],
          ),
          bottomNavigationBar: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
              child: Container(
                height: 72,
                decoration: BoxDecoration(
                  color: AppPalette.bg,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppPalette.baseBlack.withValues(alpha: 0.10),
                      blurRadius: 22,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    _NavItem(
                      label: 'Home',
                      icon: Icons.home_rounded,
                      selected: state.selectedTab == DashboardTab.home,
                      onTap: () => _select(context, DashboardTab.home),
                    ),
                    _NavItem(
                      label: 'Challenge',
                      icon: Icons.emoji_events_outlined,
                      selected: state.selectedTab == DashboardTab.challenge,
                      onTap: () => _select(context, DashboardTab.challenge),
                    ),
                    Expanded(
                      child: Center(
                        child: GestureDetector(
                          onTap: () => _select(context, DashboardTab.run),
                          child: Container(
                            width: 48,
                            height: 48,
                            decoration: const BoxDecoration(
                              color: AppPalette.bgFillPrimary,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.directions_run_rounded,
                              color: AppPalette.baseWhite,
                              size: 29,
                            ),
                          ),
                        ),
                      ),
                    ),
                    _NavItem(
                      label: 'Activity',
                      icon: Icons.monitor_heart_outlined,
                      selected: state.selectedTab == DashboardTab.activity,
                      onTap: () => _select(context, DashboardTab.activity),
                    ),
                    _NavItem(
                      label: 'Profile',
                      icon: Icons.person_outline_rounded,
                      selected: state.selectedTab == DashboardTab.profile,
                      onTap: () => _select(context, DashboardTab.profile),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _select(BuildContext context, DashboardTab tab) {
    context.read<DashboardCubit>().selectTab(tab);
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected
        ? AppPalette.bgFillPrimary
        : AppPalette.textNeutralSecondary;

    return Expanded(
      child: Material(
        color: AppPalette.baseBlack.withValues(alpha: 0),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 23, color: color),
              const SizedBox(height: 4),
              Text(
                label,
                maxLines: 1,
                style: TextStyle(
                  fontSize: 11,
                  height: 1.1,
                  color: color,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RunScreen extends StatelessWidget {
  const _RunScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppPalette.bgPrimary,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.directions_run_rounded,
                size: 64,
                color: AppPalette.bgFillPrimary,
              ),
              SizedBox(height: 16),
              Text(
                'Start Running',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppPalette.textNeutralPrimary,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Running screen will be available soon.',
                style: TextStyle(
                  fontSize: 13,
                  color: AppPalette.textNeutralPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

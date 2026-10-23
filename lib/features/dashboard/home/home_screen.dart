import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:runca/ui/color.dart';

import '../activity/cubit/activity_cubit.dart';
import '../activity/cubit/activity_state.dart';
import '../activity/models/activity_model.dart';
import '../challenge/challenge_detail_screen.dart';
import '../challenge/cubit/challenge_cubit.dart';
import '../challenge/models/challenge_model.dart';
import '../cubit/dashboard_cubit.dart';
import '../cubit/dashboard_state.dart';
import 'cubit/home_cubit.dart';
import 'cubit/home_state.dart';
import 'widgets/challenge_card.dart';
import 'widgets/home_header.dart';
import 'widgets/streak_card.dart';
import 'widgets/weekly_calendar.dart';
import 'widgets/weekly_stats.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => HomeCubit()..loadHome()),
        BlocProvider(create: (_) => ActivityCubit()),
      ],
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatefulWidget {
  const _HomeView();

  @override
  State<_HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<_HomeView> {
  bool isOutdoor = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPalette.bg,
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            return SingleChildScrollView(
              physics: const ClampingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              padding: const EdgeInsets.only(bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 22),
                    child: HomeHeader(),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: StreakCard(streak: 0),
                  ),
                  const SizedBox(height: 28),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: WeeklyCalendar(),
                  ),
                  const SizedBox(height: 22),
                  const Divider(
                    height: 1,
                    thickness: 4,
                    color: AppPalette.borderNeutral,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Expanded(
                              child: Text(
                                'This Week',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: AppPalette.textNeutralPrimary,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                color: AppPalette.bgSurfaceNeutral,
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: Row(
                                children: [
                                  _ActivityToggle(
                                    label: 'Indoor',
                                    selected: !isOutdoor,
                                    onTap: () {
                                      setState(() => isOutdoor = false);
                                    },
                                  ),
                                  _ActivityToggle(
                                    label: 'Outdoor',
                                    selected: isOutdoor,
                                    onTap: () {
                                      setState(() => isOutdoor = true);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        WeeklyStats(isOutdoor: isOutdoor),
                      ],
                    ),
                  ),

                  // Last Activity hanya muncul jika aktivitas tersedia.
                  BlocBuilder<ActivityCubit, ActivityState>(
                    builder: (context, activityState) {
                      if (activityState.status != ActivityStatus.success ||
                          activityState.activities.isEmpty) {
                        return const SizedBox.shrink();
                      }

                      final activities = [...activityState.activities]
                        ..sort((a, b) => b.startedAt.compareTo(a.startedAt));

                      final latestActivity = activities.first;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Divider(
                            height: 1,
                            thickness: 4,
                            color: AppPalette.borderNeutral,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                            child: Row(
                              children: [
                                const Expanded(
                                  child: Text(
                                    'Last Activity',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: AppPalette.textNeutralPrimary,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    context.read<DashboardCubit>().openActivity(
                                      ActivityTab.activities,
                                    );
                                  },
                                  child: const Text(
                                    'View All',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: AppPalette.bgFillPrimary,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                            child: _LastActivityCard(activity: latestActivity),
                          ),
                        ],
                      );
                    },
                  ),

                  const Divider(
                    height: 1,
                    thickness: 4,
                    color: AppPalette.borderNeutral,
                  ),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                    child: Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'New Challenge',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppPalette.textNeutralPrimary,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            context.read<DashboardCubit>().selectTab(
                              DashboardTab.challenge,
                            );
                          },
                          child: const Text(
                            'See all',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppPalette.bgFillPrimary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  ...ChallengeCubit.dummyChallenges
                      .take(2)
                      .map(
                        (challenge) => ChallengeCard(
                          challenge: challenge,
                          onTap: () => _openChallengeDetail(context, challenge),
                        ),
                      ),

                  const SizedBox(height: 12),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _openChallengeDetail(BuildContext context, ChallengeModel challenge) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ChallengeDetailScreen(challenge: challenge),
      ),
    );
  }
}

class _LastActivityCard extends StatelessWidget {
  const _LastActivityCard({required this.activity});

  final ActivityModel activity;

  @override
  Widget build(BuildContext context) {
    final date = activity.startedAt;
    final dateText =
        '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';

    final durationMinutes = activity.durationSeconds ~/ 60;
    final durationSeconds = activity.durationSeconds % 60;

    final paceMinutes = activity.avgPaceSecondsPerKm ~/ 60;
    final paceSeconds = activity.avgPaceSecondsPerKm % 60;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppPalette.baseWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppPalette.baseBlack.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppPalette.bgFillSecondary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _activityIcon(activity.type),
                  color: AppPalette.bgFillPrimary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      activity.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppPalette.textNeutralPrimary,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '${activity.type.label} • $dateText',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppPalette.textNeutralSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _ActivityValue(
                  label: 'Distance',
                  value: '${activity.distanceKm.toStringAsFixed(2)} km',
                ),
              ),
              Expanded(
                child: _ActivityValue(
                  label: 'Duration',
                  value:
                      '$durationMinutes:'
                      '${durationSeconds.toString().padLeft(2, '0')}',
                ),
              ),
              Expanded(
                child: _ActivityValue(
                  label: 'Avg Pace',
                  value:
                      "$paceMinutes'"
                      '${paceSeconds.toString().padLeft(2, '0')}"/km',
                ),
              ),
              Expanded(
                child: _ActivityValue(
                  label: 'Calories',
                  value: '${activity.calories} kcal',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _activityIcon(ActivityType type) {
    switch (type) {
      case ActivityType.running:
        return Icons.directions_run_rounded;
      case ActivityType.treadmill:
        return Icons.fitness_center_rounded;
      case ActivityType.cycling:
        return Icons.directions_bike_rounded;
    }
  }
}

class _ActivityValue extends StatelessWidget {
  const _ActivityValue({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppPalette.textNeutralPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 10,
            color: AppPalette.textNeutralSecondary,
          ),
        ),
      ],
    );
  }
}

class _ActivityToggle extends StatelessWidget {
  const _ActivityToggle({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? AppPalette.baseWhite
              : AppPalette.baseBlack.withValues(alpha: 0),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
            color: AppPalette.textNeutralPrimary,
          ),
        ),
      ),
    );
  }
}

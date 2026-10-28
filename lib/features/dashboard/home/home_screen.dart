import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:runca/features/dashboard/activity/cubit/activity_cubit.dart';
import 'package:runca/features/dashboard/challenge/challenge_detail_screen.dart';
import 'package:runca/features/dashboard/challenge/cubit/challenge_cubit.dart';
import 'package:runca/ui/color.dart';
import 'package:runca/utility/snackbar_extension.dart';

import 'cubit/home_cubit.dart';
import 'cubit/home_state.dart';
import 'widgets/home_challenges_section.dart';
import 'widgets/home_error_view.dart';
import 'widgets/home_header.dart';
import 'widgets/home_last_activity_section.dart';
import 'widgets/home_section_divider.dart';
import 'widgets/home_weekly_section.dart';
import 'widgets/streak_card.dart';
import 'widgets/weekly_calendar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => HomeCubit()),
        BlocProvider(create: (_) => ActivityCubit()),
        BlocProvider(create: (_) => ChallengeCubit()),
      ],
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  void _showRefreshError(BuildContext context) {
    context.read<HomeCubit>().clearError();
    context.showInfoSnackbar('Unable to refresh home data. Try again.');
  }

  void _openChallengeDetail(BuildContext context, String challengeId) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ChallengeDetailScreen(challengeId: challengeId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPalette.bg,
      body: SafeArea(
        bottom: false,
        child: BlocListener<HomeCubit, HomeState>(
          listener: (context, state) {
            if (state.hasError) _showRefreshError(context);
          },
          child: BlocBuilder<HomeCubit, HomeState>(builder: _buildBody),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, HomeState state) {
    final cubit = context.read<HomeCubit>();

    if (state.status == HomeStatus.loading && state.overview == null) {
      return const Center(
        child: CircularProgressIndicator(color: AppPalette.bgFillPrimary),
      );
    }

    final overview = state.overview;
    final weeklyStats = state.weeklyStats;
    final profile = state.profile;

    if (state.status == HomeStatus.failure ||
        overview == null ||
        weeklyStats == null ||
        profile == null) {
      return HomeErrorView(onRetry: cubit.loadHome);
    }

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
            child: HomeHeader(name: profile.name),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: StreakCard(streak: overview.streak),
          ),
          const SizedBox(height: 28),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: WeeklyCalendar(weekDays: overview.weekDays),
          ),
          const SizedBox(height: 22),
          const HomeSectionDivider(),
          HomeWeeklySection(
            stats: weeklyStats,
            activityType: state.activityType,
            onActivityTypeChanged: cubit.selectActivityType,
          ),
          const HomeLastActivitySection(),
          HomeChallengesSection(
            onChallengeTap: (id) => _openChallengeDetail(context, id),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:runca/ui/color.dart';
import 'package:runca/features/dashboard/cubit/dashboard_cubit.dart';
import 'package:runca/features/dashboard/home/leaderboard/leaderboard_screen.dart';
import 'package:runca/features/dashboard/home/notifications/notifications_screen.dart';
import 'package:runca/utility/format_utils.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key, required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: const BoxDecoration(
            color: AppPalette.bgSurfaceNeutral,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.person_rounded,
            color: AppPalette.iconNeutralSecondary,
            size: 30,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hi, ${AppFormat.firstName(name)}',
                style: TextStyle(
                  fontSize: 14,
                  color: AppPalette.textNeutralSecondary,
                ),
              ),
              SizedBox(height: 5),
              Text(
                'Ready for a run?',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppPalette.textNeutralPrimary,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const LeaderboardScreen(),
              ),
            );
          },
          tooltip: 'Leaderboard',
          icon: const Icon(
            Icons.leaderboard_outlined,
            size: 24,
            color: AppPalette.textNeutralPrimary,
          ),
        ),
        IconButton(
          onPressed: () {
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
          tooltip: 'Notifications',
          icon: const Icon(
            Icons.notifications_none_rounded,
            size: 25,
            color: AppPalette.textNeutralPrimary,
          ),
        ),
      ],
    );
  }
}

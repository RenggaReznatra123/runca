import 'package:flutter/material.dart';
import 'package:runca/ui/color.dart';
import 'package:runca/utility/format_utils.dart';

class StreakCard extends StatelessWidget {
  const StreakCard({super.key, required this.streak});

  final int streak;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppPalette.bg,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: AppPalette.textNeutralSecondary,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.local_fire_department_rounded,
              color: AppPalette.baseWhite,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppFormat.dayStreak(streak),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppPalette.textNeutralSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  streak == 0
                      ? 'Start a run today to kick off your streak!'
                      : 'Keep going to maintain your streak!',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppPalette.textDisabled,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

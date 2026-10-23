import 'package:flutter/material.dart';

import 'package:runca/ui/color.dart';
import 'package:runca/utility/format_utils.dart';

import '../models/leaderboard_model.dart';
import 'leaderboard_avatar.dart';

class CurrentUserRank extends StatelessWidget {
  const CurrentUserRank({super.key, required this.runner});

  final LeaderboardRunner runner;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: AppPalette.bgSurfacePrimary,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: AppPalette.baseBlack.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          LeaderboardAvatar(
            imageUrl: runner.avatarUrl,
            size: 44,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Your rank',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppPalette.textNeutralSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '#${runner.rank} · '
                  '${AppFormat.distanceValue(runner.distanceKm)} km',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppPalette.bgFillPrimary,
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

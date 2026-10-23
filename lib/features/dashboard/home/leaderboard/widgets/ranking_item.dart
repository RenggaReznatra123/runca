import 'package:flutter/material.dart';

import 'package:runca/ui/color.dart';
import '../cubit/leaderboard_state.dart';

class RankingItem extends StatelessWidget {
  const RankingItem({super.key, required this.runner});

  final LeaderboardRunner runner;

  @override
  Widget build(BuildContext context) {
    final isCurrentUser = runner.isCurrentUser;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
      decoration: BoxDecoration(
        color: isCurrentUser
            ? AppPalette.bgSurfacePrimary
            : AppPalette.baseWhite,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isCurrentUser
              ? AppPalette.bgHoverPrimary
              : AppPalette.borderDisabled,
        ),
        boxShadow: [
          if (!isCurrentUser)
            BoxShadow(
              color: AppPalette.baseBlack.withValues(alpha: 0.02),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            width: 24,
            child: Text(
              '${runner.rank}',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: isCurrentUser
                    ? AppPalette.bgFillPrimary
                    : AppPalette.textNeutralPrimary,
              ),
            ),
          ),
          const SizedBox(width: 16),

          Container(
            width: 46,
            height: 46,
            decoration: const BoxDecoration(
              color: AppPalette.bgSurfaceNeutral,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.person_rounded,
              size: 29,
              color: AppPalette.iconNeutralSecondary,
            ),
          ),

          const SizedBox(width: 18),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  runner.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: isCurrentUser
                        ? AppPalette.bgFillPrimary
                        : AppPalette.textNeutralPrimary,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  runner.formattedDistance,
                  style: TextStyle(
                    fontSize: 14,
                    color: isCurrentUser
                        ? AppPalette.bgFillPrimary
                        : AppPalette.textNeutralSecondary,
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

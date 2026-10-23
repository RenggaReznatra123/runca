import 'package:flutter/material.dart';

import 'package:runca/ui/color.dart';

class LeaderboardHeader extends StatelessWidget {
  const LeaderboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 58,
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 22,
              color: AppPalette.textNeutralPrimary,
            ),
          ),
          const SizedBox(width: 12),
          const Text(
            'Leaderboard',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppPalette.textNeutralPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

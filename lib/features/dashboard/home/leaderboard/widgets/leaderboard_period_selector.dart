import 'package:flutter/material.dart';

import 'package:runca/ui/color.dart';
import '../cubit/leaderboard_state.dart';

class LeaderboardPeriodSelector extends StatelessWidget {
  const LeaderboardPeriodSelector({
    super.key,
    required this.selectedPeriod,
    required this.onChanged,
  });

  final LeaderboardPeriod selectedPeriod;
  final ValueChanged<LeaderboardPeriod> onChanged;

  static const _periods = [
    LeaderboardPeriod.thisWeek,
    LeaderboardPeriod.thisMonth,
    LeaderboardPeriod.allTime,
  ];

  static const _labels = ['This Week', 'This Month', 'All Time'];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: AppPalette.bgSurfaceNeutral,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: List.generate(_periods.length, (index) {
          final selected = selectedPeriod == _periods[index];

          return Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => onChanged(_periods[index]),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: selected
                      ? AppPalette.baseWhite
                      : AppPalette.baseBlack.withValues(alpha: 0),
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: selected
                      ? [
                          BoxShadow(
                            color: AppPalette.baseBlack.withValues(alpha: 0.05),
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Text(
                  _labels[index],
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                    color: AppPalette.textNeutralPrimary,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

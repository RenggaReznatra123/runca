import 'package:flutter/material.dart';

import 'package:runca/ui/color.dart';
import 'package:runca/ui/typography.dart';

import '../cubit/activity_state.dart';

class ActivityTabs extends StatelessWidget {
  const ActivityTabs({
    super.key,
    required this.selectedTab,
    required this.onChanged,
  });

  final ActivityTab selectedTab;
  final ValueChanged<ActivityTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: _ActivityTabItem(
              label: 'Progress',
              selected: selectedTab == ActivityTab.progress,
              onTap: () => onChanged(ActivityTab.progress),
            ),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: _ActivityTabItem(
              label: 'Activities',
              selected: selectedTab == ActivityTab.activities,
              onTap: () => onChanged(ActivityTab.activities),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActivityTabItem extends StatelessWidget {
  const _ActivityTabItem({
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
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 46,
            child: Center(
              child: Text(
                label,
                style:
                    AppTypography.titleSmall(
                      color: selected
                          ? AppPalette.bgFillPrimary
                          : AppPalette.textNeutralSecondary,
                    ).copyWith(
                      fontWeight: selected
                          ? AppTypography.medium
                          : AppTypography.regular,
                    ),
              ),
            ),
          ),
          Container(
            height: 2,
            color: selected
                ? AppPalette.bgFillPrimary
                : AppPalette.baseBlack.withValues(alpha: 0),
          ),
        ],
      ),
    );
  }
}

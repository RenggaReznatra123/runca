import 'package:flutter/material.dart';

import 'package:runca/ui/color.dart';
import 'package:runca/ui/typography.dart';

import '../cubit/challenge_state.dart';

class ChallengeTabs extends StatelessWidget {
  const ChallengeTabs({
    super.key,
    required this.selectedTab,
    required this.onChanged,
  });

  final ChallengeTab selectedTab;
  final ValueChanged<ChallengeTab> onChanged;

  static const _labels = {
    ChallengeTab.discover: 'Discover',
    ChallengeTab.active: 'Active',
    ChallengeTab.history: 'History',
  };

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          for (final tab in ChallengeTab.values)
            Expanded(
              child: _ChallengeTabItem(
                label: _labels[tab] ?? '',
                selected: tab == selectedTab,
                onTap: () => onChanged(tab),
              ),
            ),
        ],
      ),
    );
  }
}

class _ChallengeTabItem extends StatelessWidget {
  const _ChallengeTabItem({
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

import 'package:flutter/material.dart';

import 'package:runca/ui/color.dart';
import 'package:runca/ui/typography.dart';

import '../cubit/challenge_state.dart';

class ChallengeFilterChips extends StatelessWidget {
  const ChallengeFilterChips({
    super.key,
    required this.selectedFilter,
    required this.onChanged,
  });

  final ChallengeFilter selectedFilter;
  final ValueChanged<ChallengeFilter> onChanged;

  @override
  Widget build(BuildContext context) {
    final filters = ChallengeFilter.values;

    return SizedBox(
      height: 34,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: filters.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final filter = filters[index];

          return _FilterChip(
            label: filter.label,
            selected: filter == selectedFilter,
            onTap: () => onChanged(filter),
          );
        },
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
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
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? AppPalette.bgFillPrimary : AppPalette.baseWhite,
          borderRadius: BorderRadius.circular(30),
          border: selected ? null : Border.all(color: AppPalette.borderNeutral),
        ),
        child: Text(
          label,
          maxLines: 1,
          style:
              AppTypography.bodyMedium(
                color: selected
                    ? AppPalette.textWhitePrimary
                    : AppPalette.textNeutralPrimary,
              ).copyWith(
                fontSize: 13,
                fontWeight: selected
                    ? AppTypography.medium
                    : AppTypography.regular,
              ),
        ),
      ),
    );
  }
}

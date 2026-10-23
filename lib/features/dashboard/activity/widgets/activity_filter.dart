import 'package:flutter/material.dart';

import 'package:runca/ui/color.dart';
import 'package:runca/ui/typography.dart';

import '../cubit/activity_state.dart';

class ActivityFilterChips extends StatelessWidget {
  const ActivityFilterChips({
    super.key,
    required this.selectedFilter,
    required this.onChanged,
  });

  final ActivityFilter selectedFilter;
  final ValueChanged<ActivityFilter> onChanged;

  @override
  Widget build(BuildContext context) {
    final filters = ActivityFilter.values;

    return SizedBox(
      height: 37,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
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
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: AppPalette.baseBlack.withValues(alpha: 0.15),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
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
                fontSize: 15,
                fontWeight: selected
                    ? AppTypography.medium
                    : AppTypography.regular,
              ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import 'package:runca/ui/color.dart';
import 'package:runca/ui/typography.dart';

import '../../cubit/activity_state.dart';

class ProgressStatsHeader extends StatelessWidget {
  const ProgressStatsHeader({
    super.key,
    required this.selectedFilter,
    required this.onFilterChanged,
  });

  final ActivityFilter selectedFilter;
  final ValueChanged<ActivityFilter> onFilterChanged;

  static String _labelOf(ActivityFilter filter) {
    return filter == ActivityFilter.all ? 'All Activities' : filter.label;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 39,
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Stats',
              style: AppTypography.titleLarge(
                color: AppPalette.textNeutralPrimary,
              ),
            ),
          ),
          PopupMenuButton<ActivityFilter>(
            tooltip: '',
            position: PopupMenuPosition.under,
            color: AppPalette.baseWhite,
            surfaceTintColor: AppPalette.baseWhite,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            onSelected: onFilterChanged,
            itemBuilder: (context) => [
              for (final filter in ActivityFilter.values)
                PopupMenuItem<ActivityFilter>(
                  value: filter,
                  child: Text(
                    _labelOf(filter),
                    style:
                        AppTypography.bodyMedium(
                          color: AppPalette.textNeutralPrimary,
                        ).copyWith(
                          fontWeight: filter == selectedFilter
                              ? AppTypography.medium
                              : AppTypography.regular,
                        ),
                  ),
                ),
            ],
            child: Container(
              height: 39,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 18),
              decoration: BoxDecoration(
                color: AppPalette.bgSurfaceNeutral,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _labelOf(selectedFilter),
                    style: AppTypography.bodyMedium(
                      color: AppPalette.textNeutralPrimary,
                    ).copyWith(fontSize: 15),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 22,
                    color: AppPalette.textNeutralPrimary,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

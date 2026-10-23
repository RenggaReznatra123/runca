import 'package:flutter/material.dart';

import 'package:runca/ui/color.dart';
import 'package:runca/ui/typography.dart';

import '../models/progress_model.dart';

class ProgressPeriodSelector extends StatelessWidget {
  const ProgressPeriodSelector({
    super.key,
    required this.selectedPeriod,
    required this.onChanged,
  });

  final ProgressPeriod selectedPeriod;
  final ValueChanged<ProgressPeriod> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppPalette.bgSurfaceNeutral,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          for (final period in ProgressPeriod.values)
            Expanded(
              child: _PeriodItem(
                label: period.label,
                selected: period == selectedPeriod,
                onTap: () => onChanged(period),
              ),
            ),
        ],
      ),
    );
  }
}

class _PeriodItem extends StatelessWidget {
  const _PeriodItem({
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
          label,
          maxLines: 1,
          style: AppTypography.bodyMedium(color: AppPalette.textNeutralPrimary)
              .copyWith(
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

import 'package:flutter/material.dart';

import 'package:runca/ui/color.dart';
import 'package:runca/ui/typography.dart';

import '../models/help_model.dart';

/// Chip kategori FAQ (All, Tracking & GPS, Account).
class FaqCategoryChips extends StatelessWidget {
  const FaqCategoryChips({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final FaqFilter selected;
  final ValueChanged<FaqFilter> onChanged;

  @override
  Widget build(BuildContext context) {
    final filters = FaqFilter.values;

    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: filters.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final filter = filters[index];

          return _CategoryChip(
            label: filter.label,
            selected: filter == selected,
            onTap: () => onChanged(filter),
          );
        },
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
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
          color: selected ? AppPalette.profileAccent : AppPalette.baseWhite,
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

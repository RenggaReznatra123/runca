import 'package:flutter/material.dart';

import 'package:runca/ui/color.dart';
import 'package:runca/ui/typography.dart';

/// Barisan chip pill yang bisa digeser. Chip terpilih berwarna tosca.
class PillChipBar<T> extends StatelessWidget {
  const PillChipBar({
    super.key,
    required this.values,
    required this.selected,
    required this.labelOf,
    required this.onChanged,
  });

  final List<T> values;
  final T selected;
  final String Function(T value) labelOf;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: values.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final value = values[index];

          return _PillChip(
            label: labelOf(value),
            selected: value == selected,
            onTap: () => onChanged(value),
          );
        },
      ),
    );
  }
}

class _PillChip extends StatelessWidget {
  const _PillChip({
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

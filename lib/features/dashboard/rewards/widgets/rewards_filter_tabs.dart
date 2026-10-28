import 'package:flutter/material.dart';

import 'package:runca/ui/color.dart';
import 'package:runca/ui/typography.dart';

class RewardsFilterTabs<T> extends StatelessWidget {
  const RewardsFilterTabs({
    super.key,
    required this.options,
    required this.selected,
    required this.labelBuilder,
    required this.onChanged,
  });

  final List<T> options;
  final T selected;
  final String Function(T option) labelBuilder;
  final ValueChanged<T> onChanged;

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
          for (final option in options)
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => onChanged(option),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: selected == option
                        ? AppPalette.baseWhite
                        : AppPalette.baseWhite.withValues(alpha: 0),
                    borderRadius: BorderRadius.circular(26),
                    boxShadow: selected == option
                        ? [
                            BoxShadow(
                              color: AppPalette.baseBlack.withValues(
                                alpha: 0.06,
                              ),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  child: Text(
                    labelBuilder(option),
                    maxLines: 1,
                    style:
                        AppTypography.bodyMedium(
                          color: AppPalette.textNeutralPrimary,
                        ).copyWith(
                          fontWeight: selected == option
                              ? AppTypography.medium
                              : AppTypography.regular,
                        ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

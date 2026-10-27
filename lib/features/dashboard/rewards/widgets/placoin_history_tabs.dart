import 'package:flutter/material.dart';

import 'package:runca/ui/color.dart';
import 'package:runca/ui/typography.dart';

import '../models/placoin_transaction_model.dart';

/// Tab pill All / Earned / Spent.
class PlaCoinHistoryTabs extends StatelessWidget {
  const PlaCoinHistoryTabs({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final PlaCoinHistoryFilter selected;
  final ValueChanged<PlaCoinHistoryFilter> onChanged;

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
          for (final filter in PlaCoinHistoryFilter.values)
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => onChanged(filter),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: selected == filter
                        ? AppPalette.baseWhite
                        : AppPalette.baseWhite.withValues(alpha: 0),
                    borderRadius: BorderRadius.circular(26),
                    boxShadow: selected == filter
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
                    filter.label,
                    maxLines: 1,
                    style:
                        AppTypography.bodyMedium(
                          color: AppPalette.textNeutralPrimary,
                        ).copyWith(
                          fontWeight: selected == filter
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

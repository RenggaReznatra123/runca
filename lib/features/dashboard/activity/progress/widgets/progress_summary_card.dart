import 'package:flutter/material.dart';

import 'package:runca/ui/color.dart';
import 'package:runca/ui/typography.dart';

class ProgressSummaryCard extends StatelessWidget {
  const ProgressSummaryCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.value,
    required this.change,
    required this.isIncrease,
    required this.comparisonLabel,
    this.unit,
    this.selected = false,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String value;
  final String? unit;
  final String change;
  final bool isIncrease;
  final String comparisonLabel;
  final bool selected;

  static const double width = 133;

  @override
  Widget build(BuildContext context) {
    final unitText = unit;

    return Container(
      width: width,
      padding: const EdgeInsets.fromLTRB(14, 11, 14, 11),
      decoration: BoxDecoration(
        color: AppPalette.baseWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: selected ? AppPalette.bgFillPrimary : AppPalette.borderNeutral,
          width: selected ? 1.5 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 20, color: iconColor),
                const SizedBox(width: 4),
                Text(
                  title,
                  maxLines: 1,
                  style: AppTypography.bodyMedium(
                    color: AppPalette.textNeutralPrimary,
                  ).copyWith(fontSize: 15, height: 1.4),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: value,
                    style: AppTypography.headlineSmall(
                      color: AppPalette.textNeutralPrimary,
                    ).copyWith(height: 1.25),
                  ),
                  if (unitText != null)
                    TextSpan(
                      text: ' $unitText',
                      style: AppTypography.bodyMedium(
                        color: AppPalette.textNeutralSecondary,
                      ),
                    ),
                ],
              ),
              maxLines: 1,
            ),
          ),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isIncrease
                      ? Icons.arrow_upward_rounded
                      : Icons.arrow_downward_rounded,
                  size: 14,
                  color: AppPalette.textSuccess,
                ),
                const SizedBox(width: 4),
                Text(
                  change,
                  style: AppTypography.bodyMedium(color: AppPalette.textSuccess)
                      .copyWith(
                        fontSize: 14,
                        height: 1.3,
                        fontWeight: AppTypography.medium,
                      ),
                ),
                const SizedBox(width: 6),
                Text(
                  comparisonLabel,
                  style: AppTypography.bodySmall(
                    color: AppPalette.textNeutralSecondary,
                  ).copyWith(fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

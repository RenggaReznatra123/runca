import 'package:flutter/material.dart';

import 'package:runca/ui/color.dart';
import 'package:runca/ui/typography.dart';

class PersonalRecordItem extends StatelessWidget {
  const PersonalRecordItem({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.unit,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final String unit;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppPalette.baseWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppPalette.borderNeutral),
      ),
      child: Row(
        children: [
          Icon(icon, size: 24, color: iconColor),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.bodyMedium(
                color: AppPalette.textNeutralPrimary,
              ).copyWith(fontSize: 13),
            ),
          ),
          const SizedBox(width: 8),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: value,
                  style: AppTypography.headlineSmall(
                    color: AppPalette.textNeutralPrimary,
                  ).copyWith(height: 1.25),
                ),
                TextSpan(
                  text: ' $unit',
                  style: AppTypography.bodyMedium(
                    color: AppPalette.textNeutralSecondary,
                  ),
                ),
              ],
            ),
            maxLines: 1,
          ),
        ],
      ),
    );
  }
}

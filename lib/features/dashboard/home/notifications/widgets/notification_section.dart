import 'package:flutter/material.dart';

import 'package:runca/ui/color.dart';
import 'package:runca/ui/typography.dart';

class NotificationSection extends StatelessWidget {
  const NotificationSection({
    super.key,
    required this.title,
    required this.date,
  });

  final String title;
  final String date;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            title,
            style:
                AppTypography.titleMedium(
                  color: AppPalette.textNeutralPrimary,
                ).copyWith(
                  fontSize: 14.5,
                  fontWeight: AppTypography.medium,
                  height: 1.3,
                ),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          date,
          style: AppTypography.bodyMedium(
            color: AppPalette.textNeutralSecondary,
          ).copyWith(fontSize: 12, height: 1.4),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

import 'package:runca/ui/color.dart';
import 'package:runca/ui/typography.dart';
import 'package:runca/utility/format_utils.dart';

class RunSummaryHeader extends StatelessWidget {
  const RunSummaryHeader({
    super.key,
    required this.startedAt,
    this.title = 'Run Complete!',
  });

  final DateTime startedAt;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTypography.titleLarge(color: AppPalette.textSuccess),
        ),
        const SizedBox(height: 4),
        Text(
          'Great work! Here\u2019s your run summary.',
          style: AppTypography.bodyLarge(color: AppPalette.profileMutedText),
        ),
        const SizedBox(height: 4),
        Text(
          AppFormat.runDateTime(startedAt),
          style: AppTypography.bodyMedium(color: AppPalette.profileMutedText),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

import 'package:runca/ui/color.dart';
import 'package:runca/ui/typography.dart';

class ChallengeRequirementList extends StatelessWidget {
  const ChallengeRequirementList({super.key, required this.items});

  final List<String> items;

  @override
  Widget build(BuildContext context) {
    final style = AppTypography.bodyMedium(
      color: AppPalette.textNeutralPrimary,
    );

    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Column(
        children: [
          for (var i = 0; i < items.length; i++)
            Padding(
              padding: EdgeInsets.only(bottom: i == items.length - 1 ? 0 : 9),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(width: 14, child: Text('${i + 1}.', style: style)),
                  Expanded(child: Text(items[i], style: style)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';

import 'package:runca/ui/color.dart';
import 'package:runca/ui/typography.dart';

/// Kartu abu-abu "+ Calories" atau "+ Distance" di ringkasan Treadmill.
class TreadmillSummaryAddCard extends StatelessWidget {
  const TreadmillSummaryAddCard({
    super.key,
    required this.label,
    required this.onTap,
  });

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppPalette.bgSurfaceNeutral,
      borderRadius: BorderRadius.circular(4),
      child: InkWell(
        borderRadius: BorderRadius.circular(4),
        onTap: onTap,
        child: SizedBox(
          height: 85,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.add_rounded,
                size: 24,
                color: AppPalette.profileMutedIcon,
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: AppTypography.bodyLarge(
                  color: AppPalette.profileMutedText,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

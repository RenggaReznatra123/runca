import 'package:flutter/material.dart';

import 'package:runca/ui/color.dart';
import 'package:runca/ui/typography.dart';

class ActivityErrorBanner extends StatelessWidget {
  const ActivityErrorBanner({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
        decoration: BoxDecoration(
          color: AppPalette.bgSurfaceInfo,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppPalette.borderNeutral),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.info_rounded,
              size: 16,
              color: AppPalette.textNeutralPrimary,
            ),
            const SizedBox(width: 9),
            Expanded(
              child: Text(
                message,
                style: AppTypography.bodyMedium(
                  color: AppPalette.textNeutralPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

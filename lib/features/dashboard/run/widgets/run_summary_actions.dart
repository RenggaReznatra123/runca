import 'package:flutter/material.dart';

import 'package:runca/ui/color.dart';
import 'package:runca/ui/typography.dart';

/// Tombol bawah layar ringkasan: Back to Home dan View Activity Details.
class RunSummaryActions extends StatelessWidget {
  const RunSummaryActions({
    super.key,
    required this.onBackToHome,
    required this.onViewDetails,
  });

  final VoidCallback onBackToHome;
  final VoidCallback onViewDetails;

  @override
  Widget build(BuildContext context) {
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: onBackToHome,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppPalette.profileAccent,
                foregroundColor: AppPalette.baseWhite,
                elevation: 0,
                shape: shape,
              ),
              child: Text(
                'Back to Home',
                style: AppTypography.titleSmall(color: AppPalette.baseWhite),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: OutlinedButton(
              onPressed: onViewDetails,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(
                  color: AppPalette.borderButtonOutlinedDefault,
                ),
                shape: shape,
              ),
              child: Text(
                'View Activity Details',
                style: AppTypography.titleSmall(
                  color: AppPalette.textNeutralPrimary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
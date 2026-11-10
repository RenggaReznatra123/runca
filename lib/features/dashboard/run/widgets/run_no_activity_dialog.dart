import 'package:flutter/material.dart';

import 'package:runca/ui/color.dart';
import 'package:runca/ui/typography.dart';

/// Dialog saat Finish ditekan tapi belum ada data lari.
/// Mengembalikan true kalau pengguna memilih Discard Run.
class RunNoActivityDialog extends StatelessWidget {
  const RunNoActivityDialog({super.key});

  static Future<bool?> show(BuildContext context) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const RunNoActivityDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    );

    return Dialog(
      backgroundColor: AppPalette.bgModal,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'No Activity Recorded',
              textAlign: TextAlign.center,
              style: AppTypography.titleMedium(
                color: AppPalette.textNeutralPrimary,
              ).copyWith(fontWeight: AppTypography.medium),
            ),
            const SizedBox(height: 8),
            Text(
              'You haven\u2019t run yet. Nothing will be saved to your '
              'activity history.',
              textAlign: TextAlign.center,
              style: AppTypography.bodyMedium(
                color: AppPalette.profileMutedText,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        side: const BorderSide(
                          color: AppPalette.borderButtonOutlinedDefault,
                        ),
                        shape: shape,
                      ),
                      child: Text(
                        'Continue Run',
                        style: AppTypography.bodyMedium(
                          color: AppPalette.textNeutralPrimary,
                        ).copyWith(fontWeight: AppTypography.medium),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        backgroundColor: AppPalette.bgFillDanger,
                        foregroundColor: AppPalette.baseWhite,
                        elevation: 0,
                        shape: shape,
                      ),
                      child: Text(
                        'Discard Run',
                        style: AppTypography.bodyMedium(
                          color: AppPalette.baseWhite,
                        ).copyWith(fontWeight: AppTypography.medium),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
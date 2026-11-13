import 'package:flutter/material.dart';

import 'package:runca/ui/color.dart';
import 'package:runca/ui/typography.dart';

/// Dialog konfirmasi hapus aktivitas. Mengembalikan true kalau dikonfirmasi.
class ActivityDeleteDialog {
  const ActivityDeleteDialog._();

  static Future<bool> show(
    BuildContext context, {
    required String activityTitle,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      barrierColor: AppPalette.overlayBlack54,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: AppPalette.baseWhite,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 32, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Delete Activity?',
                  textAlign: TextAlign.center,
                  style: AppTypography.titleLarge(
                    color: AppPalette.settingsDarkText,
                  ).copyWith(fontWeight: AppTypography.bold),
                ),
                const SizedBox(height: 14),
                Text(
                  '\u201C$activityTitle\u201D will be permanently removed from '
                  'your activity history. This action cannot be undone.',
                  textAlign: TextAlign.center,
                  style: AppTypography.bodyMedium(
                    color: AppPalette.profileMutedText,
                  ).copyWith(height: 1.7),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 46,
                        child: OutlinedButton(
                          onPressed: () =>
                              Navigator.of(dialogContext).pop(false),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                              color: AppPalette.profileSoftBorder,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: Text(
                            'Cancel',
                            style: AppTypography.bodyLarge(
                              color: AppPalette.settingsDarkText,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SizedBox(
                        height: 46,
                        child: ElevatedButton(
                          onPressed: () =>
                              Navigator.of(dialogContext).pop(true),
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: AppPalette.settingsDangerButton,
                            foregroundColor: AppPalette.baseWhite,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: Text(
                            'Delete Activity',
                            maxLines: 1,
                            style: AppTypography.bodyLarge(
                              color: AppPalette.baseWhite,
                            ),
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
      },
    );

    return result ?? false;
  }
}

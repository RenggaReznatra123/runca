
import 'package:flutter/material.dart';

import 'package:runca/ui/color.dart';
import 'package:runca/ui/typography.dart';

class SettingsLogoutDialog {
  const SettingsLogoutDialog._();

  static Future<bool> show(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black54,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.white,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Log Out of Plarita?',
                  textAlign: TextAlign.center,
                  style: AppTypography.titleLarge(
                    color: AppPalette.settingsDarkText,
                  ).copyWith(fontSize: 23),
                ),
                const SizedBox(height: 18),
                Text(
                  'Are you sure you want to log out? All your synced '
                  'running activities and PlaCoins will remain safe.',
                  textAlign: TextAlign.center,
                  style: AppTypography.bodyMedium(
                    color: AppPalette.profileMutedText,
                  ).copyWith(
                    fontSize: 14,
                    height: 1.8,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 54,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.of(dialogContext).pop(false);
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppPalette.settingsDarkText,
                            side: const BorderSide(
                              color: AppPalette.profileSoftBorder,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: Text(
                            'Cancel',
                            style: AppTypography.bodyMedium(
                              color: AppPalette.settingsDarkText,
                            ).copyWith(fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: SizedBox(
                        height: 54,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(dialogContext).pop(true);
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: AppPalette.settingsDangerButton,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: Text(
                            'Log Out',
                            style: AppTypography.bodyMedium(
                              color: Colors.white,
                            ).copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
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

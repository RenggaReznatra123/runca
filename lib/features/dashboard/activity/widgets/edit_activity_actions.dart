import 'package:flutter/material.dart';

import 'package:runca/ui/color.dart';
import 'package:runca/ui/typography.dart';

/// Tombol bawah layar Edit Activity: Save Changes dan Cancel.
class EditActivityActions extends StatelessWidget {
  const EditActivityActions({
    super.key,
    required this.canSave,
    required this.isSaving,
    required this.onSave,
    required this.onCancel,
  });

  final bool canSave;
  final bool isSaving;
  final VoidCallback onSave;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton(
              onPressed: canSave && !isSaving ? onSave : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppPalette.profileAccent,
                foregroundColor: AppPalette.baseWhite,
                // Saat menyimpan, tombol nonaktif tapi tetap berwarna aktif.
                disabledBackgroundColor: isSaving
                    ? AppPalette.profileAccent
                    : AppPalette.profileDisabledFill,
                disabledForegroundColor: isSaving
                    ? AppPalette.baseWhite
                    : AppPalette.profileMutedIcon,
                elevation: 0,
                shape: shape,
              ),
              child: isSaving
                  ? const SizedBox.square(
                      dimension: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: AppPalette.baseWhite,
                      ),
                    )
                  : Text('Save Changes', style: AppTypography.titleSmall()),
            ),
          ),
          const SizedBox(height: 9),
          SizedBox(
            width: double.infinity,
            height: 44,
            child: OutlinedButton(
              onPressed: isSaving ? null : onCancel,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(
                  color: AppPalette.borderButtonOutlinedDefault,
                ),
                shape: shape,
              ),
              child: Text(
                'Cancel',
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

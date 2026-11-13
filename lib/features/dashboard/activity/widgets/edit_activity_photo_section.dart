import 'package:flutter/material.dart';

import 'package:runca/ui/color.dart';
import 'package:runca/ui/shared_view/app_image.dart';
import 'package:runca/ui/typography.dart';
import 'package:runca/utility/format_utils.dart';

/// Bagian "Activity photo": foto, Change Photo, Remove Photo, dan kotak
/// kamera untuk menambah foto.
class EditActivityPhotoSection extends StatelessWidget {
  const EditActivityPhotoSection({
    super.key,
    required this.photoPath,
    required this.onChange,
    required this.onRemove,
    required this.onAdd,
  });

  final String? photoPath;
  final VoidCallback onChange;
  final VoidCallback onRemove;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final photo = photoPath;
    final hasPhoto = photo != null && photo.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Activity photo',
                style: AppTypography.bodyLarge(
                  color: AppPalette.textNeutralPrimary,
                ).copyWith(fontWeight: AppTypography.medium),
              ),
            ),
            Text(
              AppFormat.photoCount(hasPhoto ? 1 : 0),
              style: AppTypography.bodyMedium(
                color: AppPalette.profileMutedText,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (hasPhoto) ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: AppImage(path: photo, width: 112, height: 108),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 43,
                        child: OutlinedButton(
                          onPressed: onChange,
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 22),
                            side: const BorderSide(
                              color: AppPalette.borderButtonOutlinedDefault,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'Change Photo',
                            style: AppTypography.bodyLarge(
                              color: AppPalette.textNeutralPrimary,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: onRemove,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Text(
                            'Remove Photo',
                            style: AppTypography.bodyLarge(
                              color: AppPalette.textDanger,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
        _AddPhotoTile(onTap: onAdd),
      ],
    );
  }
}

class _AddPhotoTile extends StatelessWidget {
  const _AddPhotoTile({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Material(
        color: AppPalette.baseWhite,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AppPalette.borderNeutral),
        ),
        child: InkWell(
          customBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          onTap: onTap,
          child: const SizedBox(
            width: 112,
            height: 110,
            child: Icon(
              Icons.photo_camera_outlined,
              size: 30,
              color: AppPalette.profileMutedIcon,
            ),
          ),
        ),
      ),
    );
  }
}
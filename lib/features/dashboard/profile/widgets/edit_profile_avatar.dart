import 'package:flutter/material.dart';

import 'package:runca/ui/color.dart';
import 'package:runca/ui/shared_view/app_image.dart';

/// Foto profil bulat dengan badge kamera di kanan bawah.
class EditProfileAvatar extends StatelessWidget {
  const EditProfileAvatar({
    super.key,
    required this.avatarUrl,
    required this.onCameraTap,
  });

  final String? avatarUrl;
  final VoidCallback onCameraTap;

  static const double _size = 100;
  static const double _badgeSize = 26;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _size,
      height: _size,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          ClipOval(
            child: AppImage(
              path: avatarUrl,
              width: _size,
              height: _size,
              placeholder: const _AvatarPlaceholder(),
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: GestureDetector(
              onTap: onCameraTap,
              child: Container(
                width: _badgeSize,
                height: _badgeSize,
                decoration: BoxDecoration(
                  color: AppPalette.profileAccent,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppPalette.baseWhite, width: 2),
                ),
                child: const Icon(
                  Icons.photo_camera_rounded,
                  size: 12,
                  color: AppPalette.baseWhite,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AvatarPlaceholder extends StatelessWidget {
  const _AvatarPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: EditProfileAvatar._size,
      height: EditProfileAvatar._size,
      child: ColoredBox(
        color: AppPalette.bgSurfaceNeutral,
        child: Center(
          child: Icon(
            Icons.person_outline_rounded,
            size: 48,
            color: AppPalette.textNeutralSecondary,
          ),
        ),
      ),
    );
  }
}
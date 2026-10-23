import 'package:flutter/material.dart';
import 'package:runca/features/dashboard/profile/models/profile_model.dart';
import 'package:runca/ui/color.dart';
import 'package:runca/ui/typography.dart';

class ProfileInfo extends StatelessWidget {
  const ProfileInfo({
    super.key,
    required this.profile,
    required this.onEditTap,
  });

  final ProfileModel profile;
  final VoidCallback onEditTap;

  static const Color _buttonBorder = Color(0xFFC8D4E3);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipOval(
          child: profile.avatarUrl != null && profile.avatarUrl!.isNotEmpty
              ? Image.network(
                  profile.avatarUrl!,
                  width: 56,
                  height: 56,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => _avatarFallback(),
                )
              : _avatarFallback(),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                profile.name.isEmpty ? 'Your Name' : profile.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.titleMedium(
                  color: AppPalette.textNeutralPrimary,
                ).copyWith(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 3),
              Text(
                profile.location.isEmpty
                    ? 'Location not set'
                    : profile.location,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.bodySmall(
                  color: AppPalette.textNeutralSecondary,
                ).copyWith(fontSize: 12),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        OutlinedButton(
          onPressed: onEditTap,
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(0, 34),
            padding: const EdgeInsets.symmetric(horizontal: 14),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            foregroundColor: AppPalette.textNeutralPrimary,
            side: const BorderSide(color: _buttonBorder),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(11),
            ),
          ),
          child: Text(
            'Edit Profile',
            style: AppTypography.bodySmall(
              color: AppPalette.textNeutralPrimary,
            ).copyWith(fontSize: 12),
          ),
        ),
      ],
    );
  }

  Widget _avatarFallback() {
    return Container(
      width: 56,
      height: 56,
      color: const Color(0xFFF1F1F1),
      alignment: Alignment.center,
      child: const Icon(
        Icons.person_outline_rounded,
        size: 32,
        color: AppPalette.textNeutralSecondary,
      ),
    );
  }
}

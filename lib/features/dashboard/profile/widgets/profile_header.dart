import 'package:flutter/material.dart';
import 'package:runca/ui/color.dart';
import 'package:runca/ui/typography.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key, required this.onSettingsTap});

  final VoidCallback onSettingsTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 34,
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Profile',
              style: AppTypography.titleLarge(
                color: AppPalette.textNeutralPrimary,
              ).copyWith(fontSize: 20, fontWeight: FontWeight.w600),
            ),
          ),
          IconButton(
            onPressed: onSettingsTap,
            tooltip: 'Settings',
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints.tightFor(width: 32, height: 32),
            icon: const Icon(
              Icons.settings_outlined,
              size: 23,
              color: AppPalette.textNeutralPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

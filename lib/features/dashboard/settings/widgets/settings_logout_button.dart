import 'package:flutter/material.dart';
import 'package:runca/ui/typography.dart';

class SettingsLogoutButton extends StatelessWidget {
  const SettingsLogoutButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFFFF0F0),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          width: double.infinity,
          height: 56,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Logout',
                style: AppTypography.bodyMedium(
                  color: const Color(0xFFFF3030),
                ).copyWith(fontSize: 16),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:runca/ui/color.dart';

class ProfileSetupHeading extends StatelessWidget {
  const ProfileSetupHeading({
    required this.title,
    required this.subtitle,
    super.key,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 26,
            height: 1.3,
            fontWeight: FontWeight.w400,
            color: AppPalette.textNeutralPrimary,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          subtitle,
          style: const TextStyle(
            fontSize: 14,
            height: 1.5,
            color: AppPalette.textNeutralPrimary,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:runca/ui/color.dart';
import 'package:runca/ui/typography.dart';

class SettingsHeader extends StatelessWidget {
  const SettingsHeader({super.key, required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: Row(
        children: [
          IconButton(
            onPressed: onBack,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints.tightFor(width: 32, height: 40),
            icon: const Icon(
              Icons.chevron_left_rounded,
              size: 28,
              color: AppPalette.textNeutralPrimary,
            ),
          ),
          const SizedBox(width: 0),
          Text(
            'Settings',
            style: AppTypography.titleMedium(
              color: AppPalette.textNeutralPrimary,
            ).copyWith(fontSize: 17, fontWeight: AppTypography.medium),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

import 'package:runca/ui/color.dart';
import 'package:runca/ui/typography.dart';

/// Pilihan jenis target (Distance atau Time) di sheet Set a Goal.
class RunGoalOption extends StatelessWidget {
  const RunGoalOption({
    super.key,
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected
        ? AppPalette.profileAccent
        : AppPalette.profileMutedText;

    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: selected ? AppPalette.bgSurfacePrimary : AppPalette.baseWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: selected ? AppPalette.profileAccent : AppPalette.borderNeutral,
          width: selected ? 1.5 : 1,
        ),
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 26, color: color),
              const SizedBox(height: 6),
              Text(
                label,
                style: AppTypography.titleSmall(color: color).copyWith(
                  fontWeight: selected
                      ? AppTypography.medium
                      : AppTypography.regular,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

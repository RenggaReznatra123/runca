import 'package:flutter/material.dart';

import 'package:runca/ui/color.dart';
import 'package:runca/ui/typography.dart';

class ProgressDateNavigator extends StatelessWidget {
  const ProgressDateNavigator({
    super.key,
    required this.title,
    required this.date,
    required this.onPrevious,
    required this.onNext,
  });

  final String title;
  final String date;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 24,
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.bodyMedium(
                color: AppPalette.textNeutralPrimary,
              ).copyWith(fontSize: 15),
            ),
          ),
          _ArrowButton(icon: Icons.chevron_left_rounded, onTap: onPrevious),
          const SizedBox(width: 20),
          Text(
            date,
            maxLines: 1,
            style: AppTypography.bodyMedium(
              color: AppPalette.textNeutralPrimary,
            ).copyWith(fontSize: 13, fontWeight: AppTypography.medium),
          ),
          const SizedBox(width: 20),
          _ArrowButton(icon: Icons.chevron_right_rounded, onTap: onNext),
        ],
      ),
    );
  }
}

class _ArrowButton extends StatelessWidget {
  const _ArrowButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: SizedBox(
        width: 24,
        height: 24,
        child: Icon(icon, size: 24, color: AppPalette.textNeutralPrimary),
      ),
    );
  }
}

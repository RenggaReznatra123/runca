import 'package:flutter/material.dart';

import 'package:runca/ui/color.dart';

/// Judul bagian di Home. Di kanan bisa berisi tautan ([actionLabel] dan
/// [onActionTap]) atau widget lain lewat [trailing].
class HomeSectionHeader extends StatelessWidget {
  const HomeSectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onActionTap,
    this.trailing,
  });

  final String title;
  final String? actionLabel;
  final VoidCallback? onActionTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final label = actionLabel;

    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppPalette.textNeutralPrimary,
            ),
          ),
        ),
        if (label != null)
          GestureDetector(
            onTap: onActionTap,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: AppPalette.bgFillPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ?trailing,
      ],
    );
  }
}

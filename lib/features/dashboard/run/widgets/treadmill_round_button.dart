import 'package:flutter/material.dart';

import 'package:runca/ui/color.dart';

/// Tombol bulat besar dengan bayangan (play di Setup Treadmill).
class TreadmillRoundButton extends StatelessWidget {
  const TreadmillRoundButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.size = 104,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppPalette.profileAccent.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: AppPalette.profileAccent,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onPressed,
          child: Icon(icon, size: size * 0.4, color: AppPalette.baseWhite),
        ),
      ),
    );
  }
}

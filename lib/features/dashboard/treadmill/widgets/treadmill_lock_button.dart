import 'package:flutter/material.dart';

import 'package:runca/ui/color.dart';

/// Tombol gembok kecil di samping Pause. Tap untuk mengunci layar.
class TreadmillLockButton extends StatelessWidget {
  const TreadmillLockButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppPalette.baseWhite,
      shape: const CircleBorder(
        side: BorderSide(color: AppPalette.borderNeutral),
      ),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onPressed,
        child: const Icon(
          Icons.lock_outline_rounded,
          size: 26,
          color: AppPalette.iconNeutralPrimary,
        ),
      ),
    );
  }
}

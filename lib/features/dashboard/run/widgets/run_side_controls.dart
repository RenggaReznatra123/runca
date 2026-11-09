import 'package:flutter/material.dart';

import 'package:runca/ui/color.dart';

/// Tombol layer peta dan "ke lokasiku" di kanan peta.
class RunSideControls extends StatelessWidget {
  const RunSideControls({
    super.key,
    required this.onLayersTap,
    required this.onLocateTap,
  });

  final VoidCallback onLayersTap;
  final VoidCallback onLocateTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52,
      padding: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: AppPalette.baseWhite.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: AppPalette.baseBlack.withValues(alpha: 0.08),
            blurRadius: 12,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ControlButton(icon: Icons.layers_outlined, onTap: onLayersTap),
          _ControlButton(icon: Icons.my_location_outlined, onTap: onLocateTap),
        ],
      ),
    );
  }
}

class _ControlButton extends StatelessWidget {
  const _ControlButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      icon: Icon(icon, size: 24),
      color: AppPalette.iconNeutralPrimary,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
    );
  }
}

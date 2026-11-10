import 'package:flutter/material.dart';

import 'package:runca/ui/color.dart';

/// Wadah panel bawah layar lari: sudut atas melengkung, bayangan, dan handle.
class RunPanelShell extends StatelessWidget {
  const RunPanelShell({super.key, required this.child});

  /// Tinggi panel tanpa area gesture sistem di bawah.
  static const double contentHeight = 267;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Container(
      height: contentHeight + bottomInset,
      decoration: BoxDecoration(
        color: AppPalette.baseWhite,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: AppPalette.baseBlack.withValues(alpha: 0.12),
            blurRadius: 24,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(
            width: 126,
            height: 4,
            decoration: BoxDecoration(
              color: AppPalette.profileSoftBorder,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}

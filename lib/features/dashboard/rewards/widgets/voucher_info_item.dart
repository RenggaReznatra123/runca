import 'package:flutter/material.dart';

import 'package:runca/ui/color.dart';

class VoucherInfoItem extends StatelessWidget {
  const VoucherInfoItem({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: const BoxDecoration(
              color: AppPalette.bgSurfaceNeutral,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 25, color: AppPalette.iconNeutralSecondary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppPalette.textNeutralSecondary,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    color: AppPalette.textNeutralPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

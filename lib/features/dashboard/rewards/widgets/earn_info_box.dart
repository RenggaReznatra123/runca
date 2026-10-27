import 'package:flutter/material.dart';

import 'package:runca/ui/color.dart';
import 'package:runca/ui/typography.dart';

/// Kotak info di bawah daftar cara mendapatkan PlaCoins.
class EarnInfoBox extends StatelessWidget {
  const EarnInfoBox({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        color: AppPalette.bgSurfacePrimary,
        border: Border.all(color: AppPalette.profileAccent),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 1),
            child: Icon(
              Icons.info_rounded,
              size: 20,
              color: AppPalette.profileAccent,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: AppTypography.bodyMedium(
                color: AppPalette.profileMutedText,
              ).copyWith(height: 18 / 14),
            ),
          ),
        ],
      ),
    );
  }
}

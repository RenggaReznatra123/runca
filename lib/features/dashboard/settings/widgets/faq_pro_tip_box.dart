import 'package:flutter/material.dart';

import 'package:runca/ui/color.dart';
import 'package:runca/ui/typography.dart';

/// Kotak "Pro Tip" di dalam jawaban FAQ.
class FaqProTipBox extends StatelessWidget {
  const FaqProTipBox({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final style = AppTypography.bodySmall(
      color: AppPalette.textNeutralPrimary,
    ).copyWith(height: 18 / 12);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppPalette.bgSurfacePrimary,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppPalette.profileAccent),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 1),
            child: Icon(
              Icons.info_rounded,
              size: 16,
              color: AppPalette.profileAccent,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Pro Tip: ',
                    style: style.copyWith(fontWeight: AppTypography.semiBold),
                  ),
                  TextSpan(text: message),
                ],
              ),
              style: style,
            ),
          ),
        ],
      ),
    );
  }
}

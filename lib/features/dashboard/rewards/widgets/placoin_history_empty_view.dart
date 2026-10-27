import 'package:flutter/material.dart';

import 'package:runca/ui/color.dart';
import 'package:runca/ui/typography.dart';

/// Tampilan riwayat PlaCoins yang masih kosong.
class PlaCoinHistoryEmptyView extends StatelessWidget {
  const PlaCoinHistoryEmptyView({super.key, required this.onHowToEarn});

  final VoidCallback onHowToEarn;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 88, 20, 24),
      child: Column(
        children: [
          const DecoratedBox(
            decoration: BoxDecoration(
              color: AppPalette.bgSurfacePrimary,
              shape: BoxShape.circle,
            ),
            child: SizedBox(
              width: 56,
              height: 56,
              child: Icon(
                Icons.schedule_outlined,
                size: 24,
                color: AppPalette.textNeutralPrimary,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No transactions yet',
            textAlign: TextAlign.center,
            style: AppTypography.titleLarge(
              color: AppPalette.profileDarkText,
            ).copyWith(fontSize: 20),
          ),
          const SizedBox(height: 12),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 330),
            child: Text(
              'Welcome! You haven\u2019t earned or spent any PlaCoins. '
              'Your transactions will appear here when you get started.',
              textAlign: TextAlign.center,
              style: AppTypography.bodyMedium(
                color: AppPalette.profileMutedText,
              ).copyWith(height: 24 / 14),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: OutlinedButton(
              onPressed: onHowToEarn,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppPalette.textNeutralPrimary,
                side: const BorderSide(color: AppPalette.profileSoftBorder),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'How to Earn PlaCoins',
                style: AppTypography.titleSmall().copyWith(
                  fontWeight: AppTypography.regular,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

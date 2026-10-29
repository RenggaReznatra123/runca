import 'package:flutter/material.dart';

import 'package:runca/ui/color.dart';
import 'package:runca/ui/typography.dart';

/// Tampilan tab Active dan History yang masih kosong.
class ChallengeEmptyView extends StatelessWidget {
  const ChallengeEmptyView({
    super.key,
    required this.illustrationAsset,
    required this.fallbackIcon,
    required this.title,
    required this.message,
    required this.onExplore,
  });

  /// Export ilustrasi dari Figma dan simpan di path ini.
  final String illustrationAsset;

  /// Ikon pengganti kalau file ilustrasi belum ada.
  final IconData fallbackIcon;
  final String title;
  final String message;
  final VoidCallback onExplore;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 32, 20, 24),
      child: Column(
        children: [
          SizedBox(
            width: 140,
            height: 92,
            child: Image.asset(
              illustrationAsset,
              fit: BoxFit.contain,
              errorBuilder: (_, _, _) =>
                  _IllustrationFallback(icon: fallbackIcon),
            ),
          ),
          const SizedBox(height: 28),
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppTypography.titleLarge(
              color: AppPalette.textNeutralPrimary,
            ).copyWith(fontSize: 20),
          ),
          const SizedBox(height: 12),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 320),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: AppTypography.bodyMedium(
                color: AppPalette.profileMutedText,
              ).copyWith(height: 24 / 14),
            ),
          ),
          const SizedBox(height: 24),
          OutlinedButton(
            onPressed: onExplore,
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(0, 38),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              foregroundColor: AppPalette.textButtonOutlined,
              side: const BorderSide(
                color: AppPalette.borderButtonOutlinedDefault,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Explore Challenges',
              style: AppTypography.bodyMedium(
                color: AppPalette.textNeutralPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _IllustrationFallback extends StatelessWidget {
  const _IllustrationFallback({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: DecoratedBox(
        decoration: const BoxDecoration(
          color: AppPalette.bgSurfacePrimary,
          shape: BoxShape.circle,
        ),
        child: SizedBox(
          width: 88,
          height: 88,
          child: Icon(icon, size: 40, color: AppPalette.bgFillPrimary),
        ),
      ),
    );
  }
}

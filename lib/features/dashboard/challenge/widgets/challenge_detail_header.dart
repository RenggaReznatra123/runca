import 'package:flutter/material.dart';
import 'package:runca/config/app_assets.dart';
import 'package:runca/ui/color.dart';
import 'package:runca/ui/typography.dart';

import '../models/challenge_model.dart';

class ChallengeDetailHeader extends StatelessWidget {
  const ChallengeDetailHeader({
    super.key,
    required this.challenge,
    required this.onBack,
  });

  final ChallengeModel challenge;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.paddingOf(context).top;

    return Stack(
      fit: StackFit.expand,
      children: [
        _Banner(assetPath: challenge.bannerAsset),
        // Gelap di bagian bawah supaya teks putih terbaca.
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppPalette.baseBlack.withValues(alpha: 0),
                AppPalette.baseBlack.withValues(alpha: 0),
                AppPalette.baseBlack.withValues(alpha: 0.75),
              ],
              stops: const [0, 0.45, 1],
            ),
          ),
        ),
        Positioned(
          top: topInset + 28,
          left: 20,
          child: Material(
            color: AppPalette.bgHoverWarning,
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: onBack,
              child: const SizedBox(
                width: 40,
                height: 40,
                child: Icon(
                  Icons.chevron_left_rounded,
                  size: 28,
                  color: AppPalette.textNeutralPrimary,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          left: 20,
          right: 20,
          bottom: 42,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                challenge.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.headlineSmall(
                  color: AppPalette.textWhitePrimary,
                ).copyWith(fontWeight: AppTypography.medium),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Image.asset(AppAssets.placoin, width: 20, height: 20),
                  const SizedBox(width: 6),
                  Text(
                    '${challenge.formattedReward} PC',
                    maxLines: 1,
                    style: AppTypography.bodyMedium(
                      color: AppPalette.textWhitePrimary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      challenge.timeLeft,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.bodyMedium(
                        color: AppPalette.textWhitePrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Banner extends StatelessWidget {
  const _Banner({this.assetPath});

  final String? assetPath;

  @override
  Widget build(BuildContext context) {
    final path = assetPath;

    if (path == null) return const _BannerFallback();

    return Image.asset(
      path,
      fit: BoxFit.cover,
      alignment: Alignment.center,
      errorBuilder: (_, _, _) => const _BannerFallback(),
    );
  }
}

/// Pengganti sementara kalau file banner belum ada.
class _BannerFallback extends StatelessWidget {
  const _BannerFallback();

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(color: AppPalette.bgBlack);
  }
}

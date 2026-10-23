import 'package:flutter/material.dart';
import 'package:runca/config/app_assets.dart';
import 'package:runca/ui/color.dart';
import 'package:runca/ui/typography.dart';
import 'package:runca/utility/format_utils.dart';

import '../models/challenge_model.dart';

class ChallengeDetailHeader extends StatelessWidget {
  const ChallengeDetailHeader({
    super.key,
    required this.challenge,
    required this.onBack,
  });

  final ChallengeDetail challenge;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.paddingOf(context).top;

    return Stack(
      fit: StackFit.expand,
      children: [
        _Banner(imageUrl: challenge.bannerUrl),
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
                    '${AppFormat.thousands(challenge.rewardCoins)} PC',
                    maxLines: 1,
                    style: AppTypography.bodyMedium(
                      color: AppPalette.textWhitePrimary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      AppFormat.timeLeft(challenge.endDate),
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
  const _Banner({this.imageUrl});

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final path = imageUrl;

    if (path == null || path.isEmpty) return const _BannerFallback();

    final image = path.startsWith('http')
        ? Image.network(
            path,
            fit: BoxFit.cover,
            alignment: Alignment.center,
            errorBuilder: (_, _, _) => const _BannerFallback(),
          )
        : Image.asset(
            path,
            fit: BoxFit.cover,
            alignment: Alignment.center,
            errorBuilder: (_, _, _) => const _BannerFallback(),
          );
    return image;
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

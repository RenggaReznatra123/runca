import 'package:flutter/material.dart';
import 'package:runca/config/app_assets.dart';
import 'package:runca/ui/color.dart';

import '../../challenge/models/challenge_model.dart';

class ChallengeCard extends StatelessWidget {
  const ChallengeCard({
    super.key,
    required this.challenge,
    required this.onTap,
  });

  final ChallengeModel challenge;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 12),
      child: Material(
        color: AppPalette.baseBlack.withValues(alpha: 0),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(9),
                  child: _ChallengeImage(
                    imageAsset: challenge.imageAsset,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        challenge.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppPalette.textNeutralPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        challenge.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          height: 1.4,
                          color: AppPalette.textNeutralSecondary,
                        ),
                      ),
                      const SizedBox(height: 9),
                      Row(
                        children: [
                          Image(
                            image: const AssetImage(AppAssets.placoin),
                            width: 16,
                            height: 16,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            '${challenge.formattedReward} PC',
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppPalette.textNeutralPrimary,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              challenge.timeLeft,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 11,
                                color: AppPalette.textNeutralSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: AppPalette.textNeutralSecondary,
                  size: 24,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ChallengeImage extends StatelessWidget {
  const _ChallengeImage({required this.imageAsset});

  final String? imageAsset;

  @override
  Widget build(BuildContext context) {
    final path = imageAsset;

    if (path == null || path.isEmpty) {
      return const _ChallengeImageFallback();
    }

    return Image.asset(
      path,
      width: 90,
      height: 90,
      fit: BoxFit.cover,
      errorBuilder: (_, _, _) => const _ChallengeImageFallback(),
    );
  }
}

class _ChallengeImageFallback extends StatelessWidget {
  const _ChallengeImageFallback();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      height: 90,
      color: AppPalette.bgFillSecondary,
      alignment: Alignment.center,
      child: const Icon(
        Icons.directions_run_rounded,
        size: 48,
        color: AppPalette.textWhitePrimary,
      ),
    );
  }
}
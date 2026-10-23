import 'package:flutter/material.dart';
import 'package:runca/config/app_assets.dart';
import 'package:runca/ui/color.dart';
import 'package:runca/ui/typography.dart';

import '../models/challenge_model.dart';

class ChallengeItem extends StatelessWidget {
  const ChallengeItem({
    super.key,
    required this.challenge,
    required this.onTap,
  });

  final ChallengeModel challenge;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppPalette.baseBlack.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: AppPalette.baseWhite,
        borderRadius: BorderRadius.circular(12),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _ChallengeImage(assetPath: challenge.imageAsset),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              challenge.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTypography.titleSmall(
                                color: AppPalette.textNeutralPrimary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          _TypeTag(label: challenge.type.label),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        challenge.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.bodySmall(
                          color: AppPalette.textNeutralSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Image.asset(AppAssets.placoin, width: 16, height: 16),
                          const SizedBox(width: 8),
                          Text(
                            '+${challenge.formattedReward} PC',
                            maxLines: 1,
                            style: AppTypography.bodySmall(
                              color: AppPalette.textNeutralPrimary,
                            ).copyWith(fontWeight: AppTypography.medium),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              challenge.timeLeft,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTypography.bodySmall(
                                color: AppPalette.textNeutralSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
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
  const _ChallengeImage({this.assetPath});

  final String? assetPath;

  static const double _size = 90;

  @override
  Widget build(BuildContext context) {
    final path = assetPath;

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: path == null
          ? _placeholder()
          : Image.asset(
              path,
              width: _size,
              height: _size,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => _placeholder(),
            ),
    );
  }

  Widget _placeholder() {
    return Container(
      width: _size,
      height: _size,
      color: AppPalette.bgSurfaceNeutral,
      alignment: Alignment.center,
      child: const Icon(
        Icons.emoji_events_outlined,
        size: 32,
        color: AppPalette.textNeutralSecondary,
      ),
    );
  }
}

class _TypeTag extends StatelessWidget {
  const _TypeTag({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 1.5),
      decoration: BoxDecoration(
        color: AppPalette.bgSurfacePrimary,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        maxLines: 1,
        style: AppTypography.bodySmall(
          color: AppPalette.textPrimary,
        ).copyWith(fontWeight: AppTypography.medium),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import 'package:runca/config/app_assets.dart';
import 'package:runca/ui/color.dart';
import 'package:runca/ui/shared_view/app_image.dart';
import 'package:runca/utility/format_utils.dart';

import '../models/reward_model.dart';

class RewardCard extends StatelessWidget {
  const RewardCard({super.key, required this.reward, required this.onTap});

  final RewardModel reward;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppPalette.baseWhite,
      borderRadius: BorderRadius.circular(22),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1.55,
              child: AppImage(path: reward.imageUrl, width: double.infinity),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: AppPalette.bgSurfaceNeutral,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        reward.category.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 10,
                          color: AppPalette.textNeutralSecondary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${reward.brandName} - ${reward.title}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        height: 1.3,
                        fontWeight: FontWeight.w500,
                        color: AppPalette.textNeutralPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          AppAssets.placoin,
                          width: 19,
                          height: 19,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(width: 5),
                        Flexible(
                          child: Text(
                            AppFormat.thousands(reward.price),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppPalette.textSuccess,
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Flexible(
                          child: Text(
                            'PlaCoins',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
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
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';

import 'package:runca/ui/color.dart';
import 'package:runca/utility/format_utils.dart';

import '../models/leaderboard_model.dart';
import 'leaderboard_avatar.dart';

class TopRunners extends StatelessWidget {
  const TopRunners({super.key, required this.runners});

  final List<LeaderboardRunner> runners;

  @override
  Widget build(BuildContext context) {
    if (runners.length < 3) {
      return const SizedBox.shrink();
    }

    final podium = [runners[1], runners[0], runners[2]];

    return SizedBox(
      height: 205,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(podium.length, (index) {
          final runner = podium[index];
          final isFirst = runner.rank == 1;
          final avatarSize = isFirst ? 76.0 : 62.0;

          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                left: index == 0 ? 0 : 5,
                right: index == 2 ? 0 : 5,
              ),
              child: SizedBox(
                height: isFirst ? 190 : 170,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      height: 105,
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(4, 44, 4, 10),
                        decoration: BoxDecoration(
                          color: AppPalette.bgSurfaceNeutral,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              runner.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppPalette.textNeutralPrimary,
                              ),
                            ),
                            const SizedBox(height: 5),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                '${AppFormat.distanceValue(runner.distanceKm)} km',
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: AppPalette.bgFillPrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    Positioned(
                      top: isFirst ? 0 : 30,
                      child: Column(
                        children: [
                          if (isFirst)
                            const Padding(
                              padding: EdgeInsets.only(bottom: 8),
                              child: Icon(
                                Icons.workspace_premium_rounded,
                                size: 28,
                                color: AppPalette.textWarning,
                              ),
                            ),

                          LeaderboardAvatar(
                            imageUrl: runner.avatarUrl,
                            size: avatarSize,
                          ),
                        ],
                      ),
                    ),

                    Positioned(
                      top: isFirst ? 92 : 92,
                      child: Container(
                        width: 28,
                        height: 28,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: isFirst
                              ? AppPalette.bgSurfacePrimary
                              : AppPalette.bgSurfaceInfo,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppPalette.baseWhite,
                            width: 2,
                          ),
                        ),
                        child: Text(
                          '${runner.rank}',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: isFirst
                                ? AppPalette.bgFillPrimary
                                : AppPalette.textNeutralPrimary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

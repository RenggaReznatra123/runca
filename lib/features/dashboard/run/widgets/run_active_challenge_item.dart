import 'package:flutter/material.dart';

import 'package:runca/features/dashboard/challenge/models/challenge_progress.dart';
import 'package:runca/ui/color.dart';
import 'package:runca/ui/shared_view/app_image.dart';
import 'package:runca/ui/typography.dart';
import 'package:runca/utility/format_utils.dart';

/// Kartu satu challenge aktif: gambar, nama, jarak, persen, dan progress bar.
class RunActiveChallengeItem extends StatelessWidget {
  const RunActiveChallengeItem({
    super.key,
    required this.progress,
    required this.onTap,
  });

  static const double _imageSize = 60;

  final ChallengeProgress progress;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppPalette.bgPrimary,
      borderRadius: BorderRadius.circular(12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
          child: Row(
            children: [
              _Image(path: progress.imageUrl),
              const SizedBox(width: 16),
              Expanded(child: _Info(progress: progress)),
              const SizedBox(width: 32),
              const Icon(
                Icons.chevron_right_rounded,
                size: 20,
                color: AppPalette.profileMutedIcon,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Image extends StatelessWidget {
  const _Image({this.path});

  final String? path;

  @override
  Widget build(BuildContext context) {
    final image = path;

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        width: RunActiveChallengeItem._imageSize,
        height: RunActiveChallengeItem._imageSize,
        child: image == null || image.isEmpty
            ? const ColoredBox(
                color: AppPalette.bgSurfaceNeutral,
                child: Icon(
                  Icons.emoji_events_outlined,
                  size: 28,
                  color: AppPalette.textNeutralSecondary,
                ),
              )
            : AppImage(
                path: image,
                width: RunActiveChallengeItem._imageSize,
                height: RunActiveChallengeItem._imageSize,
                fit: BoxFit.cover,
              ),
      ),
    );
  }
}

class _Info extends StatelessWidget {
  const _Info({required this.progress});

  final ChallengeProgress progress;

  @override
  Widget build(BuildContext context) {
    final style = AppTypography.bodyMedium(
      color: AppPalette.textNeutralSecondary,
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          progress.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTypography.titleSmall(color: AppPalette.textNeutralPrimary),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(
              child: Text.rich(
                TextSpan(
                  style: style,
                  children: [
                    TextSpan(
                      text: AppFormat.kmShort(progress.currentKm),
                      style: style.copyWith(
                        color: AppPalette.profileAccent,
                        fontWeight: AppTypography.medium,
                      ),
                    ),
                    TextSpan(
                      text: ' / ${AppFormat.kmShort(progress.targetKm)}',
                    ),
                  ],
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              AppFormat.percent(progress.fraction),
              style: AppTypography.bodySmall(
                color: AppPalette.textNeutralPrimary,
              ).copyWith(fontWeight: AppTypography.bold),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(3),
          child: LinearProgressIndicator(
            value: progress.fraction,
            minHeight: 6,
            color: AppPalette.profileAccent,
            backgroundColor: AppPalette.bgSurfacePrimary,
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

import 'package:runca/ui/color.dart';
import 'package:runca/ui/typography.dart';
import 'package:runca/utility/format_utils.dart';

import '../models/activity_model.dart';
import 'route_map_preview.dart';

/// Kartu ringkasan aktivitas yang akan dibagikan.
class ActivityShareCard extends StatelessWidget {
  const ActivityShareCard({
    super.key,
    required this.activity,
    required this.placeName,
  });

  final ActivityModel activity;

  /// Nama tempat. Null berarti barisnya disembunyikan.
  final String? placeName;

  static const String _empty = '\u2013';

  @override
  Widget build(BuildContext context) {
    final place = placeName;
    final pace = activity.avgPaceSecondsPerKm;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppPalette.baseWhite,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppPalette.baseBlack.withValues(alpha: 0.06),
            blurRadius: 24,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // ASUMSI: logo asli dari Figma belum ada, memakai ikon pengganti.
              const Icon(
                Icons.directions_run_rounded,
                size: 32,
                color: AppPalette.profileDarkText,
              ),
              const Spacer(),
              Text(
                activity.type.label.toUpperCase(),
                style: AppTypography.bodyMedium(
                  color: AppPalette.profileMutedText,
                ).copyWith(fontWeight: AppTypography.bold, letterSpacing: 1.5),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: RouteMapPreview(
              route: activity.route,
              imagePath: activity.mapImageUrl,
              height: 149,
              strokeWidth: 4,
            ),
          ),
          if (place != null) ...[
            const SizedBox(height: 14),
            Row(
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  size: 20,
                  color: AppPalette.profileMutedIcon,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    place,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.bodyMedium(
                      color: AppPalette.profileMutedText,
                    ),
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 24),
          Text(
            activity.title,
            style: AppTypography.titleLarge(
              color: AppPalette.profileDarkText,
            ).copyWith(fontWeight: AppTypography.semiBold),
          ),
          const SizedBox(height: 4),
          Text(
            AppFormat.activityDetailDateTime(activity.startedAt),
            style: AppTypography.bodyMedium(color: AppPalette.profileMutedText),
          ),
          const SizedBox(height: 28),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: AppFormat.distanceValue(activity.distanceKm),
                  style: AppTypography.displayLarge(
                    color: AppPalette.profileDarkText,
                  ).copyWith(fontSize: 48, fontWeight: AppTypography.bold),
                ),
                TextSpan(
                  text: ' km',
                  style: AppTypography.bodyLarge(
                    color: AppPalette.profileDarkText,
                  ).copyWith(fontSize: 20, fontWeight: AppTypography.semiBold),
                ),
              ],
            ),
            maxLines: 1,
          ),
          Text(
            'Distance',
            style: AppTypography.bodyLarge(color: AppPalette.profileMutedText),
          ),
          const SizedBox(height: 24),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  width: 92,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _Stat(
                        value: pace > 0
                            ? '${AppFormat.duration(pace)} /km'
                            : _empty,
                        label: 'Avg Pace',
                      ),
                      const SizedBox(height: 16),
                      _Stat(
                        value: AppFormat.thousands(activity.calories),
                        label: 'Calories',
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 1,
                  child: ColoredBox(color: AppPalette.borderNeutral),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _Stat(
                        value: AppFormat.duration(activity.durationSeconds),
                        label: 'Duration',
                      ),
                      const SizedBox(height: 16),
                      // Elev Gain belum direkam aplikasi.
                      const _Stat(value: _empty, label: 'Elev Gain'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(
            value,
            maxLines: 1,
            style: AppTypography.titleMedium(
              color: AppPalette.profileDarkText,
            ).copyWith(fontSize: 22, fontWeight: AppTypography.semiBold),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          maxLines: 1,
          style: AppTypography.bodyMedium(color: AppPalette.profileMutedText),
        ),
      ],
    );
  }
}

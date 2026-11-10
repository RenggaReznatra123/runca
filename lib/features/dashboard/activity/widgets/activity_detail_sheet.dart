import 'package:flutter/material.dart';

import 'package:runca/features/dashboard/run/widgets/activity_type_presentation.dart';
import 'package:runca/ui/color.dart';
import 'package:runca/ui/typography.dart';
import 'package:runca/utility/format_utils.dart';

import '../models/activity_model.dart';
import 'activity_detail_stats.dart';

/// Sheet putih di bawah peta: jenis, tanggal, judul, dan statistik.
class ActivityDetailSheet extends StatelessWidget {
  const ActivityDetailSheet({super.key, required this.activity});

  final ActivityModel activity;

  /// Tinggi awal sheet sebagai bagian dari tinggi layar.
  static const double initialSize = 0.42;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: initialSize,
      minChildSize: initialSize,
      maxChildSize: 0.8,
      builder: (context, controller) {
        return DecoratedBox(
          decoration: BoxDecoration(
            color: AppPalette.baseWhite,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                color: AppPalette.baseBlack.withValues(alpha: 0.08),
                blurRadius: 12,
              ),
            ],
          ),
          child: ListView(
            controller: controller,
            physics: const ClampingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
            children: [
              Center(
                child: Container(
                  width: 126,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppPalette.profileSoftBorder,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Icon(
                    activity.type.icon,
                    size: 16,
                    color: AppPalette.profileAccent,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    activity.type.label,
                    style: AppTypography.bodyMedium(
                      color: AppPalette.profileAccent,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      ' \u00B7 ${AppFormat.activityDetailDateTime(activity.startedAt)}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.bodyMedium(
                        color: AppPalette.profileMutedText,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                activity.title,
                style: AppTypography.titleLarge(
                  color: AppPalette.textNeutralPrimary,
                ),
              ),
              const SizedBox(height: 32),
              ActivityDetailStats(activity: activity),
            ],
          ),
        );
      },
    );
  }
}

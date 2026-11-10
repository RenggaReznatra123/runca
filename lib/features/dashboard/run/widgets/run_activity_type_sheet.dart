import 'package:flutter/material.dart';

import 'package:runca/features/dashboard/activity/models/activity_model.dart';
import 'package:runca/ui/color.dart';
import 'package:runca/ui/typography.dart';

import 'activity_type_presentation.dart';
import 'run_activity_type_tile.dart';

/// Sheet pemilih olahraga: Outdoor (Cycling, Walking, Running) dan
/// Indoor (Treadmill). Mengembalikan jenis yang dipilih.
class RunActivityTypeSheet extends StatelessWidget {
  const RunActivityTypeSheet({
    super.key,
    required this.selected,
    required this.onUnavailable,
  });

  final ActivityType selected;

  /// Dipanggil dengan nama olahraga yang belum tersedia (Walking).
  final ValueChanged<String> onUnavailable;

  static Future<ActivityType?> show(
    BuildContext context, {
    required ActivityType selected,
    required ValueChanged<String> onUnavailable,
  }) {
    return showModalBottomSheet<ActivityType>(
      context: context,
      backgroundColor: AppPalette.baseWhite,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => RunActivityTypeSheet(
        selected: selected,
        onUnavailable: onUnavailable,
      ),
    );
  }

  static const double _gap = 12;

  Widget _tile(
    BuildContext context,
    ActivityType type,
  ) {
    return RunActivityTypeTile(
      icon: type.icon,
      label: type.label,
      selected: type == selected,
      onTap: () => Navigator.of(context).pop(type),
    );
  }

  @override
  Widget build(BuildContext context) {
    final labelStyle = AppTypography.bodyMedium(
      color: AppPalette.textNeutralPrimary,
    ).copyWith(fontWeight: AppTypography.medium);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
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
            const SizedBox(height: 20),
            Text('Outdoor', style: labelStyle),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(child: _tile(context, ActivityType.cycling)),
                const SizedBox(width: _gap),
                Expanded(
                  child: RunActivityTypeTile(
                    icon: Icons.directions_walk_rounded,
                    label: 'Walking',
                    selected: false,
                    onTap: () {
                      Navigator.of(context).pop();
                      onUnavailable('Walking');
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: _gap),
            Row(
              children: [
                Expanded(child: _tile(context, ActivityType.running)),
                const SizedBox(width: _gap),
                const Expanded(child: SizedBox.shrink()),
              ],
            ),
            const SizedBox(height: 16),
            Text('Indoor', style: labelStyle),
            const SizedBox(height: 10),
            _tile(context, ActivityType.treadmill),
          ],
        ),
      ),
    );
  }
}
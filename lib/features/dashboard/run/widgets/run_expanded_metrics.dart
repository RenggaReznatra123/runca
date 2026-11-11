import 'package:flutter/material.dart';

import 'package:runca/ui/color.dart';
import 'package:runca/ui/typography.dart';
import 'package:runca/utility/format_utils.dart';

/// Halaman angka di layar penuh: durasi, jarak, pace rata-rata, dan kalori.
/// Kalau [highlighted] (dijeda), blok durasi berlatar kuning.
class RunExpandedMetrics extends StatelessWidget {
  const RunExpandedMetrics({
    super.key,
    required this.distanceKm,
    required this.durationSeconds,
    required this.paceSecondsPerKm,
    required this.calories,
    required this.highlighted,
  });

  final double distanceKm;
  final int durationSeconds;
  final int? paceSecondsPerKm;
  final int calories;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 99,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.only(top: 12),
          alignment: Alignment.topCenter,
          color: highlighted
              ? AppPalette.bgHoverWarning
              : AppPalette.transparent,
          child: _BigStat(
            value: AppFormat.clockDuration(durationSeconds),
            label: 'Duration',
            fontSize: 48,
            valueHeight: 56,
            gap: 9,
          ),
        ),
        const Spacer(flex: 10),
        _BigStat(
          value: AppFormat.distanceNumber(distanceKm),
          label: 'Distance (km)',
          fontSize: 64,
          valueHeight: 76,
          gap: 7,
        ),
        const Spacer(flex: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Expanded(
                child: _BigStat(
                  value: AppFormat.paceOrPlaceholder(paceSecondsPerKm),
                  label: 'Avg Pace (/km)',
                  fontSize: 36,
                  valueHeight: 44,
                  gap: 12,
                ),
              ),
              Expanded(
                child: _BigStat(
                  value: AppFormat.clockDuration(durationSeconds),
                  label: 'Duration',
                  fontSize: 48,
                  valueHeight: 56,
                  gap: 6,
                ),
              ),
            ],
          ),
        ),
        const Spacer(flex: 11),
      ],
    );
  }
}

class _BigStat extends StatelessWidget {
  const _BigStat({
    required this.value,
    required this.label,
    required this.fontSize,
    required this.valueHeight,
    required this.gap,
  });

  final String value;
  final String label;
  final double fontSize;
  final double valueHeight;
  final double gap;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: valueHeight,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              maxLines: 1,
              style: AppTypography.headlineSmall(
                color: AppPalette.profileDarkText,
              ).copyWith(fontSize: fontSize, fontWeight: AppTypography.bold),
            ),
          ),
        ),
        SizedBox(height: gap),
        Text(
          label,
          style: AppTypography.bodyMedium(color: AppPalette.profileMutedText),
        ),
      ],
    );
  }
}

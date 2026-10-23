import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:runca/ui/color.dart';
import 'package:runca/ui/typography.dart';

import '../models/progress_model.dart';

class ProgressBarChart extends StatelessWidget {
  const ProgressBarChart({super.key, required this.bars});

  final List<ProgressBar> bars;

  static const double _maxBarHeight = 131;
  static const double _columnWidth = 51;
  static const double _barWidth = 35;

  @override
  Widget build(BuildContext context) {
    if (bars.isEmpty) return const SizedBox.shrink();

    final maxValue = bars.fold<double>(
      0,
      (max, bar) => math.max(max, bar.distanceKm),
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        // Di layar sempit, kolom dikecilkan supaya tidak overflow.
        final columnWidth = math.min(
          _columnWidth,
          constraints.maxWidth / bars.length,
        );
        final barWidth = columnWidth * _barWidth / _columnWidth;

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            for (final bar in bars)
              SizedBox(
                width: columnWidth,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: _maxBarHeight,
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          width: barWidth,
                          height: maxValue == 0
                              ? 0.0
                              : _maxBarHeight * bar.distanceKm / maxValue,
                          decoration: const BoxDecoration(
                            color: AppPalette.bgFillPrimary,
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(6),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      bar.label,
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      style: AppTypography.bodySmall(
                        color: AppPalette.textNeutralSecondary,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }
}

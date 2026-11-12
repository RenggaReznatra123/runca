import 'package:flutter/material.dart';

import 'package:runca/ui/color.dart';
import 'package:runca/ui/typography.dart';
import 'package:runca/utility/format_utils.dart';

import '../models/run_split.dart';

/// Halaman Splits di layar penuh: pace tiap lap dan selisihnya.
class RunSplitsView extends StatelessWidget {
  const RunSplitsView({
    super.key,
    required this.splits,
    required this.autoLapEnabled,
  });

  final List<RunSplit> splits;

  /// False kalau Auto Lap dimatikan di Run Settings.
  final bool autoLapEnabled;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.only(left: 28),
          child: Text(
            'Splits',
            style: AppTypography.headlineSmall(
              color: AppPalette.baseBlack,
            ).copyWith(fontSize: 28, fontWeight: AppTypography.medium),
          ),
        ),
        const SizedBox(height: 36),
        const _HeaderRow(),
        const SizedBox(height: 14),
        Expanded(
          child: splits.isEmpty
              ? Center(
                  // ASUMSI: belum ada desain kosong di Figma.
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: Text(
                      autoLapEnabled
                          ? 'Splits will appear as you run.'
                          : 'Auto Lap is off. Turn it on in Run Settings.',
                      textAlign: TextAlign.center,
                      style: AppTypography.bodyMedium(
                        color: AppPalette.profileMutedText,
                      ),
                    ),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.only(bottom: 16),
                  physics: const ClampingScrollPhysics(),
                  itemCount: splits.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 16),
                  itemBuilder: (context, index) =>
                      _SplitRow(split: splits[index]),
                ),
        ),
      ],
    );
  }
}

// Lebar kolom KM dan +/- dipakai bersama oleh header dan baris.
const double _kmColumnWidth = 56;
const double _deltaColumnWidth = 80;

class _HeaderRow extends StatelessWidget {
  const _HeaderRow();

  @override
  Widget build(BuildContext context) {
    final style = AppTypography.bodyMedium(color: AppPalette.baseBlack);

    return Padding(
      padding: const EdgeInsets.fromLTRB(28, 0, 21, 0),
      child: Row(
        children: [
          SizedBox(width: _kmColumnWidth, child: Text('KM', style: style)),
          Expanded(
            child: Center(child: Text('Pace', style: style)),
          ),
          SizedBox(
            width: _deltaColumnWidth,
            child: Center(child: Text('+/-', style: style)),
          ),
        ],
      ),
    );
  }
}

class _SplitRow extends StatelessWidget {
  const _SplitRow({required this.split});

  final RunSplit split;

  Color _deltaColor(int? delta) {
    // Baris lap yang sedang berjalan memakai teks hitam (sesuai Figma).
    if (split.isCurrent) return AppPalette.baseBlack;
    if (delta == null || delta < 0) return AppPalette.textSuccess;
    if (delta > 0) return AppPalette.textDanger;
    return AppPalette.baseBlack;
  }

  @override
  Widget build(BuildContext context) {
    final delta = split.deltaSeconds;
    final smallStyle = AppTypography.bodyMedium(color: AppPalette.baseBlack);

    return Container(
      height: 48,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.only(left: 9, right: 5),
      decoration: BoxDecoration(
        color: split.isCurrent
            ? AppPalette.bgHoverInfo
            : AppPalette.transparent,
        border: split.isCurrent
            ? const Border(
                left: BorderSide(color: AppPalette.profileAccent, width: 3),
              )
            : null,
      ),
      child: Row(
        children: [
          SizedBox(
            width: _kmColumnWidth,
            child: Padding(
              padding: const EdgeInsets.only(left: 3),
              child: Text(
                AppFormat.lapDistance(split.distanceKm),
                style: smallStyle,
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                AppFormat.splitPace(split.paceSecondsPerKm),
                style: AppTypography.headlineSmall(
                  color: AppPalette.baseBlack,
                ).copyWith(fontSize: 36, fontWeight: AppTypography.medium),
              ),
            ),
          ),
          SizedBox(
            width: _deltaColumnWidth,
            child: Center(
              child: Text(
                delta == null ? '\u2013' : AppFormat.splitDelta(delta),
                style: smallStyle.copyWith(color: _deltaColor(delta)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
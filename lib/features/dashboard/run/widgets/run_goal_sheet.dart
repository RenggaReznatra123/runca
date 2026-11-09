import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:runca/ui/color.dart';
import 'package:runca/ui/typography.dart';
import 'package:runca/utility/format_utils.dart';

import '../models/run_goal.dart';
import 'run_goal_option.dart';
import 'run_goal_target_field.dart';

/// Sheet "Set a Goal". Menutup dengan [RunGoalSubmission] kalau disimpan,
/// atau null kalau dibatalkan.
class RunGoalSheet extends StatefulWidget {
  const RunGoalSheet({
    super.key,
    this.current,
    this.savedDistanceKm,
    this.savedTimeSeconds,
  });

  /// Target yang sedang dipakai (menentukan tab yang terbuka pertama kali).
  final RunGoal? current;

  /// Isian terakhir di tiap tab, supaya tidak hilang saat sheet dibuka lagi.
  final double? savedDistanceKm;
  final int? savedTimeSeconds;

  static Future<RunGoalSubmission?> show(
    BuildContext context, {
    RunGoal? current,
    double? savedDistanceKm,
    int? savedTimeSeconds,
  }) {
    return showModalBottomSheet<RunGoalSubmission>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppPalette.transparent,
      barrierColor: AppPalette.transparent,
      elevation: 0,
      builder: (_) => RunGoalSheet(
        current: current,
        savedDistanceKm: savedDistanceKm,
        savedTimeSeconds: savedTimeSeconds,
      ),
    );
  }

  @override
  State<RunGoalSheet> createState() => _RunGoalSheetState();
}

class _RunGoalSheetState extends State<RunGoalSheet> {
  // Jarak: sampai 3 digit dan 1 desimal. Waktu: bilangan bulat (menit).
  static final RegExp _distancePattern = RegExp(r'^\d{0,3}(\.\d?)?$');
  static final RegExp _timePattern = RegExp(r'^\d{0,3}$');

  // Tiap tab punya isian sendiri, jadi pindah tab tidak menghapus apa pun.
  final TextEditingController _distanceController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final FocusNode _distanceFocus = FocusNode();
  final FocusNode _timeFocus = FocusNode();

  late final TextInputFormatter _distanceFormatter = _formatterFor(
    _distancePattern,
  );
  late final TextInputFormatter _timeFormatter = _formatterFor(_timePattern);

  RunGoalType _type = RunGoalType.distance;

  @override
  void initState() {
    super.initState();

    _type = widget.current is TimeGoal
        ? RunGoalType.time
        : RunGoalType.distance;

    final km = widget.savedDistanceKm;
    if (km != null) _distanceController.text = AppFormat.distanceValue(km);

    final seconds = widget.savedTimeSeconds;
    if (seconds != null) {
      _timeController.text = AppFormat.integer(seconds ~/ 60);
    }

    // Tombol Save Goal ikut aktif atau nonaktif saat isian berubah.
    _distanceController.addListener(_refresh);
    _timeController.addListener(_refresh);
  }

  @override
  void dispose() {
    _distanceController.dispose();
    _timeController.dispose();
    _distanceFocus.dispose();
    _timeFocus.dispose();
    super.dispose();
  }

  void _refresh() => setState(() {});

  TextInputFormatter _formatterFor(RegExp pattern) {
    return TextInputFormatter.withFunction((oldValue, newValue) {
      // Sebagian keyboard memakai koma sebagai pemisah desimal.
      final text = newValue.text.replaceAll(',', '.');

      return pattern.hasMatch(text) ? newValue.copyWith(text: text) : oldValue;
    });
  }

  /// Null kalau isian jarak kosong atau 0.
  double? _parseDistance() {
    final text = _distanceController.text.trim();
    final km = double.tryParse(
      text.endsWith('.') ? text.substring(0, text.length - 1) : text,
    );

    return km == null || km <= 0 ? null : km;
  }

  /// Null kalau isian waktu kosong atau 0.
  int? _parseMinutes() {
    final minutes = int.tryParse(_timeController.text.trim());

    return minutes == null || minutes <= 0 ? null : minutes;
  }

  /// Target dari tab yang sedang dipilih. Null kalau isiannya belum valid.
  RunGoal? _buildGoal() {
    switch (_type) {
      case RunGoalType.distance:
        final km = _parseDistance();
        return km == null ? null : DistanceGoal(km);
      case RunGoalType.time:
        final minutes = _parseMinutes();
        return minutes == null ? null : TimeGoal(minutes * 60);
    }
  }

  void _save() {
    final goal = _buildGoal();
    if (goal == null) return;

    final minutes = _parseMinutes();

    Navigator.of(context).pop(
      RunGoalSubmission(
        goal: goal,
        distanceKm: _parseDistance(),
        timeSeconds: minutes == null ? null : minutes * 60,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final keyboard = media.viewInsets.bottom;
    final bottom = (keyboard > 0 ? keyboard : media.padding.bottom) + 24;
    final isDistance = _type == RunGoalType.distance;

    return Container(
      padding: EdgeInsets.fromLTRB(20, 12, 20, bottom),
      decoration: BoxDecoration(
        color: AppPalette.baseWhite,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: AppPalette.baseBlack.withValues(alpha: 0.12),
            blurRadius: 24,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
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
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Set a Goal',
                        style:
                            AppTypography.titleLarge(
                              color: AppPalette.textNeutralPrimary,
                            ).copyWith(
                              fontSize: 20,
                              fontWeight: AppTypography.medium,
                            ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Choose a target for your run.',
                        style: AppTypography.bodyMedium(
                          color: AppPalette.profileMutedText,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close_rounded, size: 24),
                  color: AppPalette.iconNeutralPrimary,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 32,
                    minHeight: 32,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: RunGoalOption(
                    icon: Icons.route_outlined,
                    label: 'Distance',
                    selected: isDistance,
                    onTap: () => setState(() => _type = RunGoalType.distance),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: RunGoalOption(
                    icon: Icons.schedule_outlined,
                    label: 'Time',
                    selected: !isDistance,
                    onTap: () => setState(() => _type = RunGoalType.time),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (isDistance)
              RunGoalTargetField(
                key: const ValueKey('target-distance'),
                label: 'Target Distance',
                hint: '0.0',
                unit: 'km',
                controller: _distanceController,
                focusNode: _distanceFocus,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [_distanceFormatter],
              )
            else
              RunGoalTargetField(
                key: const ValueKey('target-time'),
                label: 'Target Time',
                hint: '0',
                unit: 'min',
                controller: _timeController,
                focusNode: _timeFocus,
                keyboardType: TextInputType.number,
                inputFormatters: [_timeFormatter],
              ),
            const SizedBox(height: 16),
            SizedBox(
              height: 52,
              child: ElevatedButton(
                onPressed: _buildGoal() == null ? null : _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppPalette.profileAccent,
                  foregroundColor: AppPalette.baseWhite,
                  disabledBackgroundColor: AppPalette.profileDisabledFill,
                  disabledForegroundColor: AppPalette.profileMutedIcon,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  'Save Goal',
                  style: AppTypography.titleMedium().copyWith(
                    fontWeight: AppTypography.medium,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

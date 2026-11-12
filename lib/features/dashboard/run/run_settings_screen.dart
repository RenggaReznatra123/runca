import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:runca/features/dashboard/rewards/widgets/rewards_error_view.dart';
import 'package:runca/features/dashboard/settings/widgets/settings_choice_sheet.dart';
import 'package:runca/ui/color.dart';
import 'package:runca/ui/shared_view/app_page_header.dart';
import 'package:runca/utility/snackbar_extension.dart';

import 'cubit/run_settings_cubit.dart';
import 'cubit/run_settings_state.dart';
import 'models/run_settings.dart';
import 'widgets/run_settings_choice_row.dart';
import 'widgets/run_settings_presentation.dart';
import 'widgets/run_settings_section.dart';
import 'widgets/run_settings_toggle_row.dart';

/// Layar Run Settings: Tracking dan Audio Coach.
class RunSettingsScreen extends StatelessWidget {
  const RunSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RunSettingsCubit(),
      child: const _RunSettingsView(),
    );
  }
}

class _RunSettingsView extends StatelessWidget {
  const _RunSettingsView();

  Future<void> _pick<T>({
    required BuildContext context,
    required String title,
    required String description,
    required List<T> values,
    required T selected,
    required String Function(T value) labelOf,
    required ValueChanged<T> onSelected,
  }) async {
    final result = await SettingsChoiceSheet.show(
      context: context,
      title: title,
      description: description,
      options: [for (final value in values) labelOf(value)],
      selected: labelOf(selected),
    );

    if (result == null) return;

    onSelected(values.firstWhere((value) => labelOf(value) == result));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RunSettingsCubit, RunSettingsState>(
      listenWhen: (previous, current) =>
          !previous.saveFailed && current.saveFailed,
      listener: (context, state) {
        context.read<RunSettingsCubit>().clearSaveFailed();
        context.showErrorSnackbar('Unable to save settings. Please try again.');
      },
      child: Scaffold(
        backgroundColor: AppPalette.baseWhite,
        body: SafeArea(
          child: Column(
            children: [
              const AppPageHeader(title: 'Run Settings'),
              const Divider(height: 1, color: AppPalette.borderNeutral),
              Expanded(
                child: BlocBuilder<RunSettingsCubit, RunSettingsState>(
                  builder: _buildBody,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, RunSettingsState state) {
    final cubit = context.read<RunSettingsCubit>();

    if (state.status == RunSettingsLoadStatus.loading) {
      return const Center(
        child: CircularProgressIndicator(color: AppPalette.bgFillPrimary),
      );
    }

    if (state.status == RunSettingsLoadStatus.failure) {
      return RewardsErrorView(
        title: 'Unable to load run settings',
        onRetry: cubit.load,
      );
    }

    final settings = state.settings;

    return ListView(
      physics: const ClampingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
      children: [
        RunSettingsSection(
          title: 'TRACKING',
          children: [
            RunSettingsToggleRow(
              icon: Icons.view_column_outlined,
              title: 'Auto Pause',
              subtitle: 'Pauses when you stop to catch a breath.',
              value: settings.autoPause,
              onChanged: cubit.setAutoPause,
            ),
            RunSettingsChoiceRow(
              icon: Icons.flag_outlined,
              title: 'Auto Lap',
              subtitle: settings.autoLap.description,
              value: settings.autoLap.rowLabel,
              onTap: () => _pick<AutoLapOption>(
                context: context,
                title: 'Auto Lap Distance',
                description:
                    'Choose split interval to automatically record your laps.',
                values: AutoLapOption.values,
                selected: settings.autoLap,
                labelOf: (option) => option.sheetLabel,
                onSelected: cubit.setAutoLap,
              ),
            ),
            RunSettingsChoiceRow(
              icon: Icons.timer_outlined,
              title: 'Start Countdown',
              value: settings.countdown.rowLabel,
              onTap: () => _pick<CountdownOption>(
                context: context,
                title: 'Start Countdown',
                description:
                    'Select countdown duration before tracking starts.',
                values: CountdownOption.values,
                selected: settings.countdown,
                labelOf: (option) => option.sheetLabel,
                onSelected: cubit.setCountdown,
              ),
            ),
            RunSettingsToggleRow(
              icon: Icons.smartphone_outlined,
              title: 'Keep Screen Awake',
              subtitle: 'Keep the screen on during your run',
              value: settings.keepScreenAwake,
              onChanged: cubit.setKeepScreenAwake,
            ),
          ],
        ),
        const SizedBox(height: 24),
        RunSettingsSection(
          title: 'AUDIO COACH',
          children: [
            RunSettingsToggleRow(
              icon: Icons.keyboard_voice_outlined,
              title: 'Voice Coach',
              subtitle: 'Hear distance, pace, and time updates',
              value: settings.voiceCoach,
              onChanged: cubit.setVoiceCoach,
            ),
            if (settings.voiceCoach)
              RunSettingsChoiceRow(
                icon: Icons.record_voice_over_outlined,
                title: 'Voice Frequency',
                value: settings.voiceFrequency.rowLabel,
                onTap: () => _pick<VoiceFrequencyOption>(
                  context: context,
                  title: 'Voice Cue Frequency',
                  description:
                      'Set how often Audio Coach announces your live stats.',
                  values: VoiceFrequencyOption.values,
                  selected: settings.voiceFrequency,
                  labelOf: (option) => option.sheetLabel,
                  onSelected: cubit.setVoiceFrequency,
                ),
              ),
          ],
        ),
      ],
    );
  }
}

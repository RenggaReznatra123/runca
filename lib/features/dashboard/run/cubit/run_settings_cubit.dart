import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:runca/config/service_locator.dart';
import 'package:runca/repository/run_settings_repository.dart';
import 'package:runca/utility/resource/data_state.dart';

import '../models/run_settings.dart';
import 'run_settings_state.dart';

class RunSettingsCubit extends Cubit<RunSettingsState> {
  RunSettingsCubit({RunSettingsRepository? repository})
    : _repository = repository ?? serviceLocator.get<RunSettingsRepository>(),
      super(const RunSettingsState()) {
    load();
  }

  final RunSettingsRepository _repository;

  // Dipakai untuk mengabaikan jawaban lama kalau ada permintaan yang lebih baru.
  int _requestId = 0;

  /// Muat awal dan Try Again.
  Future<void> load() async {
    final requestId = ++_requestId;

    emit(state.copyWith(status: RunSettingsLoadStatus.loading));

    final result = await _repository.getSettings();

    if (isClosed || requestId != _requestId) return;

    final data = result is DataStateSuccess<RunSettings> ? result.data : null;

    if (data != null) {
      emit(
        state.copyWith(status: RunSettingsLoadStatus.success, settings: data),
      );
    } else {
      emit(state.copyWith(status: RunSettingsLoadStatus.failure));
    }
  }

  Future<void> setAutoPause(bool value) =>
      _update(state.settings.copyWith(autoPause: value));

  Future<void> setAutoLap(AutoLapOption value) =>
      _update(state.settings.copyWith(autoLap: value));

  Future<void> setCountdown(CountdownOption value) =>
      _update(state.settings.copyWith(countdown: value));

  Future<void> setKeepScreenAwake(bool value) =>
      _update(state.settings.copyWith(keepScreenAwake: value));

  Future<void> setVoiceCoach(bool value) =>
      _update(state.settings.copyWith(voiceCoach: value));

  Future<void> setVoiceFrequency(VoiceFrequencyOption value) =>
      _update(state.settings.copyWith(voiceFrequency: value));

  Future<void> _update(RunSettings settings) async {
    emit(state.copyWith(settings: settings));

    final result = await _repository.saveSettings(settings);

    if (isClosed) return;

    if (result is! DataStateSuccess<RunSettings>) {
      emit(state.copyWith(saveFailed: true));
    }
  }

  void clearSaveFailed() {
    if (state.saveFailed) emit(state.copyWith(saveFailed: false));
  }
}

import 'package:dio/dio.dart';

import 'package:runca/config/user_preference.dart';
import 'package:runca/data/dummy_config.dart';
import 'package:runca/features/dashboard/run/models/run_settings.dart';
import 'package:runca/repository/run_settings_repository.dart';
import 'package:runca/utility/resource/data_state.dart';

class DummyRunSettingsRepository implements RunSettingsRepository {
  DummyRunSettingsRepository(this._userPreference);

  static const String _autoPauseKey = 'run_settings_auto_pause';
  static const String _autoLapKey = 'run_settings_auto_lap';
  static const String _countdownKey = 'run_settings_countdown';
  static const String _keepAwakeKey = 'run_settings_keep_awake';
  static const String _voiceCoachKey = 'run_settings_voice_coach';
  static const String _voiceFrequencyKey = 'run_settings_voice_frequency';

  final UserPreference _userPreference;

  @override
  Future<DataState<RunSettings>> getSettings() async {
    await DummyConfig.simulateNetwork();

    switch (DummyConfig.scenario) {
      case DummyScenario.failure:
        return DummyConfig.failure<RunSettings>('/run-settings');
      case DummyScenario.empty:
        return const DataStateSuccess<RunSettings>(RunSettings());
      case DummyScenario.data:
        return DataStateSuccess<RunSettings>(_read());
    }
  }

  @override
  Future<DataState<RunSettings>> saveSettings(RunSettings settings) async {
    if (DummyConfig.scenario == DummyScenario.failure) {
      await DummyConfig.simulateNetwork();
      return DummyConfig.failure<RunSettings>('/run-settings');
    }

    try {
      final prefs = _userPreference.prefs;

      // Ditulis dulu, baru menunggu jeda tiruan, supaya pengaturan tidak
      // tertinggal kalau layar langsung ditutup.
      final saved = await Future.wait([
        prefs.setBool(_autoPauseKey, settings.autoPause),
        prefs.setString(_autoLapKey, settings.autoLap.name),
        prefs.setString(_countdownKey, settings.countdown.name),
        prefs.setBool(_keepAwakeKey, settings.keepScreenAwake),
        prefs.setBool(_voiceCoachKey, settings.voiceCoach),
        prefs.setString(_voiceFrequencyKey, settings.voiceFrequency.name),
      ]);

      if (saved.any((result) => !result)) {
        return _storageFailure<RunSettings>('/run-settings');
      }

      await DummyConfig.simulateNetwork();
      return DataStateSuccess<RunSettings>(settings);
    } catch (error) {
      return _storageFailure<RunSettings>('/run-settings', error);
    }
  }

  RunSettings _read() {
    final prefs = _userPreference.prefs;

    return RunSettings(
      autoPause: prefs.getBool(_autoPauseKey) ?? false,
      autoLap: AutoLapOption.values.firstWhere(
        (option) => option.name == prefs.getString(_autoLapKey),
        orElse: () => AutoLapOption.oneKm,
      ),
      countdown: CountdownOption.values.firstWhere(
        (option) => option.name == prefs.getString(_countdownKey),
        orElse: () => CountdownOption.three,
      ),
      keepScreenAwake: prefs.getBool(_keepAwakeKey) ?? false,
      voiceCoach: prefs.getBool(_voiceCoachKey) ?? false,
      voiceFrequency: VoiceFrequencyOption.values.firstWhere(
        (option) => option.name == prefs.getString(_voiceFrequencyKey),
        orElse: () => VoiceFrequencyOption.oneKm,
      ),
    );
  }

  DataStateError<T> _storageFailure<T>(String path, [Object? error]) {
    return DataStateError<T>(
      DioException(
        requestOptions: RequestOptions(path: path),
        type: DioExceptionType.unknown,
        message: 'Unable to access local settings.',
        error: error,
      ),
    );
  }
}

import 'package:dio/dio.dart';
import 'package:runca/config/user_preference.dart';
import 'package:runca/data/dummy_config.dart';
import 'package:runca/features/dashboard/settings/models/app_settings.dart';
import 'package:runca/repository/settings_repository.dart';
import 'package:runca/utility/resource/data_state.dart';

class DummySettingsRepository implements SettingsRepository {
  DummySettingsRepository(this._userPreference);

  static const String _languageKey = 'settings_language';
  static const String _unitsKey = 'settings_units';
  static const String _notificationsKey = 'settings_notifications';
  static const String _darkModeKey = 'settings_dark_mode';

  final UserPreference _userPreference;

  @override
  Future<DataState<AppSettings>> getSettings() async {
    await DummyConfig.simulateNetwork();

    switch (DummyConfig.scenario) {
      case DummyScenario.failure:
        return DummyConfig.failure<AppSettings>('/settings');
      case DummyScenario.empty:
        return const DataStateSuccess<AppSettings>(AppSettings());
      case DummyScenario.data:
        return DataStateSuccess<AppSettings>(_readSettings());
    }
  }

  @override
  Future<DataState<AppSettings>> saveSettings(AppSettings settings) async {
    await DummyConfig.simulateNetwork();

    if (DummyConfig.scenario == DummyScenario.failure) {
      return DummyConfig.failure<AppSettings>('/settings');
    }

    try {
      final prefs = _userPreference.prefs;
      final saved = await Future.wait([
        prefs.setString(_languageKey, settings.language.name),
        prefs.setString(_unitsKey, settings.units.name),
        prefs.setBool(_notificationsKey, settings.notificationsEnabled),
        prefs.setBool(_darkModeKey, settings.darkModeEnabled),
      ]);
      if (saved.any((result) => !result)) {
        return _storageFailure<AppSettings>('/settings');
      }
      return DataStateSuccess<AppSettings>(settings);
    } catch (error) {
      return _storageFailure<AppSettings>('/settings', error);
    }
  }

  @override
  Future<DataState<bool>> logout() async {
    await DummyConfig.simulateNetwork();

    if (DummyConfig.scenario == DummyScenario.failure) {
      return DummyConfig.failure<bool>('/settings/logout');
    }

    try {
      await _userPreference.clearSession();
      return const DataStateSuccess<bool>(true);
    } catch (error) {
      return _storageFailure<bool>('/settings/logout', error);
    }
  }

  AppSettings _readSettings() {
    final prefs = _userPreference.prefs;
    return AppSettings(
      language: AppLanguage.values.firstWhere(
        (language) => language.name == prefs.getString(_languageKey),
        orElse: () => AppLanguage.english,
      ),
      units: UnitSystem.values.firstWhere(
        (units) => units.name == prefs.getString(_unitsKey),
        orElse: () => UnitSystem.metric,
      ),
      notificationsEnabled: prefs.getBool(_notificationsKey) ?? true,
      darkModeEnabled: prefs.getBool(_darkModeKey) ?? true,
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

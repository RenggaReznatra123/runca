import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:runca/config/service_locator.dart';
import 'package:runca/features/dashboard/settings/models/app_settings.dart';
import 'package:runca/repository/settings_repository.dart';
import 'package:runca/utility/resource/data_state.dart';

import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit({SettingsRepository? repository})
    : _repository = repository ?? serviceLocator.get<SettingsRepository>(),
      super(const SettingsState()) {
    load();
  }

  final SettingsRepository _repository;

  Future<void> load() async {
    final result = await _repository.getSettings();
    if (isClosed) return;

    if (result is DataStateSuccess<AppSettings>) {
      emit(state.copyWith(settings: result.data, hasError: false));
    } else {
      emit(state.copyWith(hasError: true));
    }
  }

  Future<void> changeLanguage(AppLanguage language) =>
      _update(state.settings.copyWith(language: language));

  Future<void> changeUnits(UnitSystem units) =>
      _update(state.settings.copyWith(units: units));

  Future<void> toggleNotifications(bool enabled) =>
      _update(state.settings.copyWith(notificationsEnabled: enabled));

  // Preferensi Dark Mode hanya disimpan; tema aplikasi tetap light.
  Future<void> toggleDarkMode(bool enabled) =>
      _update(state.settings.copyWith(darkModeEnabled: enabled));

  Future<void> _update(AppSettings settings) async {
    emit(state.copyWith(settings: settings));

    final result = await _repository.saveSettings(settings);
    if (isClosed) return;

    if (result is! DataStateSuccess<AppSettings>) {
      emit(state.copyWith(hasError: true));
    }
  }

  Future<bool> logout() async {
    emit(state.copyWith(isLoggingOut: true));

    final result = await _repository.logout();
    if (isClosed) return false;

    emit(state.copyWith(isLoggingOut: false));
    return result is DataStateSuccess<bool> && result.data == true;
  }

  void clearError() {
    if (state.hasError) emit(state.copyWith(hasError: false));
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';

import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(const SettingsState());

  void changeLanguage(String language) {
    emit(state.copyWith(language: language));
  }

  void changeUnits(String units) {
    emit(state.copyWith(units: units));
  }

  void toggleNotifications(bool enabled) {
    emit(state.copyWith(notificationsEnabled: enabled));
  }

  void toggleDarkMode(bool enabled) {
    emit(state.copyWith(darkModeEnabled: enabled));
  }
}

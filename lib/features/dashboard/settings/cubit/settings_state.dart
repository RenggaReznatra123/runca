import '../models/app_settings.dart';

class SettingsState {
  const SettingsState({
    this.settings = const AppSettings(),
    this.isLoggingOut = false,
    this.hasError = false,
  });

  final AppSettings settings;
  final bool isLoggingOut;
  final bool hasError;

  SettingsState copyWith({
    AppSettings? settings,
    bool? isLoggingOut,
    bool? hasError,
  }) {
    return SettingsState(
      settings: settings ?? this.settings,
      isLoggingOut: isLoggingOut ?? this.isLoggingOut,
      hasError: hasError ?? this.hasError,
    );
  }
}

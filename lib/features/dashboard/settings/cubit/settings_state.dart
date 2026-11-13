import '../models/app_settings.dart';

class SettingsState {
  const SettingsState({
    this.settings = const AppSettings(),
    this.isLoggingOut = false,
    this.hasError = false,
    this.appVersion = '',
  });

  final AppSettings settings;
  final bool isLoggingOut;
  final bool hasError;
  final String appVersion;

  SettingsState copyWith({
    AppSettings? settings,
    bool? isLoggingOut,
    bool? hasError,
    String? appVersion,
  }) {
    return SettingsState(
      settings: settings ?? this.settings,
      isLoggingOut: isLoggingOut ?? this.isLoggingOut,
      hasError: hasError ?? this.hasError,
      appVersion: appVersion ?? this.appVersion,
    );
  }
}


class SettingsState {
  const SettingsState({
    this.language = 'English (US)',
    this.units = 'Metric (km)',
    this.notificationsEnabled = true,
    this.darkModeEnabled = true,
  });

  final String language;
  final String units;
  final bool notificationsEnabled;
  final bool darkModeEnabled;

  SettingsState copyWith({
    String? language,
    String? units,
    bool? notificationsEnabled,
    bool? darkModeEnabled,
  }) {
    return SettingsState(
      language: language ?? this.language,
      units: units ?? this.units,
      notificationsEnabled:
          notificationsEnabled ?? this.notificationsEnabled,
      darkModeEnabled: darkModeEnabled ?? this.darkModeEnabled,
    );
  }
}

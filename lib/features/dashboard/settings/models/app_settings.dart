enum AppLanguage {
  english,
  indonesian;

  String get label => switch (this) {
    AppLanguage.english => 'English (US)',
    AppLanguage.indonesian => 'Bahasa Indonesia',
  };

  String get rowLabel => switch (this) {
    AppLanguage.english => 'English',
    AppLanguage.indonesian => 'Bahasa Indonesia',
  };
}

enum UnitSystem {
  metric,
  imperial;

  String get label => switch (this) {
    UnitSystem.metric => 'Metric (km)',
    UnitSystem.imperial => 'Imperial (mi)',
  };
}

class AppSettings {
  const AppSettings({
    this.language = AppLanguage.english,
    this.units = UnitSystem.metric,
    this.notificationsEnabled = true,
    this.darkModeEnabled = true,
  });

  final AppLanguage language;
  final UnitSystem units;
  final bool notificationsEnabled;
  final bool darkModeEnabled;

  AppSettings copyWith({
    AppLanguage? language,
    UnitSystem? units,
    bool? notificationsEnabled,
    bool? darkModeEnabled,
  }) {
    return AppSettings(
      language: language ?? this.language,
      units: units ?? this.units,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      darkModeEnabled: darkModeEnabled ?? this.darkModeEnabled,
    );
  }
}

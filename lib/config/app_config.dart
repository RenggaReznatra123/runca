/// Build-time switches, set with `--dart-define`.
class AppConfig {
  const AppConfig._();

  /// Uses in-memory dummy data instead of Firebase and the real API.
  static const bool useDummyData = bool.fromEnvironment(
    'USE_DUMMY_DATA',
    defaultValue: true,
  );
}

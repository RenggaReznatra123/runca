import '../models/run_settings.dart';

enum RunSettingsLoadStatus { loading, success, failure }

class RunSettingsState {
  const RunSettingsState({
    this.status = RunSettingsLoadStatus.loading,
    this.settings = const RunSettings(),
    this.saveFailed = false,
  });

  final RunSettingsLoadStatus status;
  final RunSettings settings;

  /// True kalau penyimpanan terakhir gagal (untuk SnackBar).
  final bool saveFailed;

  RunSettingsState copyWith({
    RunSettingsLoadStatus? status,
    RunSettings? settings,
    bool? saveFailed,
  }) {
    return RunSettingsState(
      status: status ?? this.status,
      settings: settings ?? this.settings,
      saveFailed: saveFailed ?? this.saveFailed,
    );
  }
}

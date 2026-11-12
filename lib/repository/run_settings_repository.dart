import 'package:runca/features/dashboard/run/models/run_settings.dart';
import 'package:runca/utility/resource/data_state.dart';

/// Kontrak pengaturan lari (Run Settings).
abstract class RunSettingsRepository {
  Future<DataState<RunSettings>> getSettings();

  Future<DataState<RunSettings>> saveSettings(RunSettings settings);
}

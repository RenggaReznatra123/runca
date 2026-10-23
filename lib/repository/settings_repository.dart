import 'package:runca/features/dashboard/settings/models/app_settings.dart';
import 'package:runca/utility/resource/data_state.dart';

abstract class SettingsRepository {
  Future<DataState<AppSettings>> getSettings();

  Future<DataState<AppSettings>> saveSettings(AppSettings settings);

  Future<DataState<bool>> logout();
}

import 'package:runca/features/dashboard/settings/models/app_settings.dart';
import 'package:runca/features/dashboard/settings/models/change_password_result.dart';
import 'package:runca/utility/resource/data_state.dart';

abstract class SettingsRepository {
  Future<DataState<AppSettings>> getSettings();

  Future<DataState<AppSettings>> saveSettings(AppSettings settings);

  /// Ganti password. Server yang memeriksa password lama.
  Future<DataState<ChangePasswordResult>> changePassword({
    required String currentPassword,
    required String newPassword,
  });

  Future<DataState<bool>> logout();
}

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:runca/config/service_locator.dart';
import 'package:runca/repository/settings_repository.dart';
import 'package:runca/utility/resource/data_state.dart';

import '../models/change_password_result.dart';
import 'change_password_state.dart';

class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  ChangePasswordCubit({SettingsRepository? repository})
    : _repository = repository ?? serviceLocator.get<SettingsRepository>(),
      super(const ChangePasswordState());

  final SettingsRepository _repository;

  Future<void> submit({
    required String currentPassword,
    required String newPassword,
  }) async {
    if (state.status == ChangePasswordStatus.saving) return;

    emit(const ChangePasswordState(status: ChangePasswordStatus.saving));

    final result = await _repository.changePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
    );

    if (isClosed) return;

    if (result is DataStateSuccess<ChangePasswordResult>) {
      switch (result.data) {
        case ChangePasswordResult.success:
          emit(const ChangePasswordState(status: ChangePasswordStatus.success));
          return;
        case ChangePasswordResult.wrongCurrentPassword:
          emit(
            const ChangePasswordState(
              status: ChangePasswordStatus.wrongCurrentPassword,
            ),
          );
          return;
        case null:
          break;
      }
    }

    emit(const ChangePasswordState(status: ChangePasswordStatus.failure));
  }

  /// Kembali ke keadaan awal (hapus pesan error). Diabaikan saat menyimpan.
  void clearStatus() {
    if (state.status == ChangePasswordStatus.saving) return;

    emit(const ChangePasswordState());
  }
}

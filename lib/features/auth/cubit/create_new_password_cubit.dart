import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:runca/data/dummy_auth_source.dart';
import 'create_new_password_state.dart';

class CreateNewPasswordCubit extends Cubit<CreateNewPasswordState> {
  CreateNewPasswordCubit() : super(const CreateNewPasswordState());

  Future<void> createPassword(String email, String newPassword) async {
    emit(state.copyWith(status: CreateNewPasswordStatus.loading));

    try {
      final success = await DummyAuthSource.instance.resetPassword(
        email: email,
        newPassword: newPassword,
      );

      if (success) {
        emit(state.copyWith(status: CreateNewPasswordStatus.success));
      } else {
        emit(
          state.copyWith(
            status: CreateNewPasswordStatus.failure,
            errorMessage: 'Gagal memperbarui password. Coba lagi.',
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: CreateNewPasswordStatus.failure,
          errorMessage: 'Terjadi kesalahan. Silakan coba lagi.',
        ),
      );
    }
  }
}

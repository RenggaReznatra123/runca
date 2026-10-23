import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:runca/data/dummy_auth_source.dart'; // Aktifkan jika method request OTP sudah ada di dummy source
import 'reset_password_state.dart';

class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  ResetPasswordCubit() : super(const ResetPasswordState());

  Future<void> requestPasswordReset(String email) async {
    emit(state.copyWith(status: ResetPasswordStatus.loading));

    try {
      // TODO: Ganti dengan pemanggilan fungsi dari DummyAuthSource jika sudah dibuat
      await Future.delayed(const Duration(seconds: 2));

      emit(state.copyWith(status: ResetPasswordStatus.success));
    } catch (e) {
      emit(
        state.copyWith(
          status: ResetPasswordStatus.failure,
          errorMessage: 'Gagal mengirim kode verifikasi. Silakan coba lagi.',
        ),
      );
    }
  }
}

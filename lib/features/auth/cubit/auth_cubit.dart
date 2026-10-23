import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';

import 'package:runca/features/auth/dummy_auth_service.dart';
import 'package:runca/models/request/login_request.dart';
import 'package:runca/models/user_model.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  final DummyAuthService _authService = DummyAuthService();

  // Dipertahankan agar LoginScreen tetap kompatibel.
  void init() {}

  Future<void> login({required LoginRequest request}) async {
    emit(AuthStateLoading());

    try {
      final email = request.email?.trim() ?? '';
      final password = request.password ?? '';

      final isValid = await _authService.login(
        email: email,
        password: password,
      );

      if (isClosed) return;

      if (!isValid) {
        emit(
          AuthStateError(
            message: 'Email atau password yang kamu masukkan salah.',
          ),
        );
        return;
      }

      emit(
        AuthStateSuccess(
          user: UserModel(),
          accessToken: 'dummy-access-token',
          isDirector: false,
        ),
      );
    } catch (_) {
      if (isClosed) return;

      emit(AuthStateError(message: 'Login dummy gagal. Silakan coba lagi.'));
    }
  }

  Future<void> logout() async {
    emit(AuthStateSuccess(user: null, accessToken: null, isDirector: false));
  }

  // Tidak menggunakan FCM selama dummy auth.
  void updateFcmToken() {}
}

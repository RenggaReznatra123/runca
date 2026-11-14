import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';

import 'package:runca/config/service_locator.dart';
import 'package:runca/config/user_preference.dart';
import 'package:runca/features/auth/dummy_auth_service.dart';
import 'package:runca/models/request/login_request.dart';
import 'package:runca/models/user_model.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({UserPreference? userPreference})
    : _userPreference = userPreference ?? serviceLocator.get<UserPreference>(),
      super(AuthInitial());

  final DummyAuthService _authService = DummyAuthService();
  final UserPreference _userPreference;

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

      final normalizedEmail = email.toLowerCase();
      final saved = await _userPreference.setUser(
        UserModel(email: normalizedEmail),
      );
      if (!saved) throw StateError('Unable to save the user session.');
      if (isClosed) return;

      emit(
        AuthStateSuccess(
          user: UserModel(email: normalizedEmail),
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

  void reset() {
    emit(AuthInitial());
  }

  // Tidak menggunakan FCM selama dummy auth.
  void updateFcmToken() {}
}

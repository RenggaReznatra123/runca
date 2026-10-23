import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:runca/config/app_config.dart';
import 'package:runca/features/auth/dummy_auth_service.dart';

part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit() : super(SignUpInitial());

  final DummyAuthService _authService = DummyAuthService();

  static const String _notConnectedMessage =
      'Sign up API is not connected yet.';
  static const String _signUpFailedMessage =
      'Sign up failed. Please try again.';

  Future<void> signUp({required String email, required String password}) async {
    if (state is SignUpStateLoading) return;

    emit(SignUpStateLoading());

    if (!AppConfig.useDummyData) {
      // TODO: call the register endpoint through AuthRepository once the API
      // contract is known.
      emit(SignUpStateError(message: _notConnectedMessage));
      return;
    }

    try {
      final errorMessage = await _authService.signUp(
        email: email,
        password: password,
      );

      if (isClosed) return;

      if (errorMessage != null) {
        emit(SignUpStateError(message: errorMessage));
        return;
      }

      emit(SignUpStateSuccess());
    } catch (error, stackTrace) {
      debugPrint('Sign up failed: $error\n$stackTrace');
      if (isClosed) return;

      emit(SignUpStateError(message: _signUpFailedMessage));
    }
  }
}

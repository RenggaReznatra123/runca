import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:runca/data/dummy_auth_source.dart';

part 'verify_email_state.dart';

class VerifyEmailCubit extends Cubit<VerifyEmailState> {
  VerifyEmailCubit()
    : super(const VerifyEmailState(secondsLeft: codeLifetimeSeconds));

  static const int codeLength = 5;
  static const int codeLifetimeSeconds = 60;

  static const String _expiredMessage =
      'The code has expired. Please request a new one.';

  Timer? _timer;

  /// Starts the expiry countdown.
  void start() => _startCountdown();

  Future<void> verify(String code) async {
    if (state.status == VerifyEmailStatus.verifying) {
      return;
    }

    if (state.isExpired) {
      emit(
        state.copyWith(
          status: VerifyEmailStatus.failure,
          errorMessage: _expiredMessage,
        ),
      );
      return;
    }

    emit(state.copyWith(status: VerifyEmailStatus.verifying, clearError: true));

    final isValid = await DummyAuthSource.instance.verifyEmail(code: code);
    if (isClosed) {
      return;
    }

    if (isValid) {
      _timer?.cancel();
      emit(state.copyWith(status: VerifyEmailStatus.success));
    } else {
      emit(
        state.copyWith(
          status: VerifyEmailStatus.failure,
          errorMessage: DummyAuthSource.invalidCodeMessage,
        ),
      );
    }
  }

  /// Requests a new code and restarts the countdown.
  void resend() {
    // TODO: call the resend endpoint once the API contract is known.
    emit(const VerifyEmailState(secondsLeft: codeLifetimeSeconds));
    _startCountdown();
  }

  /// Hides the error as soon as the user edits the code.
  void clearError() {
    if (state.status != VerifyEmailStatus.failure) {
      return;
    }

    emit(state.copyWith(status: VerifyEmailStatus.initial, clearError: true));
  }

  void _startCountdown() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final next = state.secondsLeft - 1;

      if (next <= 0) {
        _timer?.cancel();
        emit(state.copyWith(secondsLeft: 0));
        return;
      }

      emit(state.copyWith(secondsLeft: next));
    });
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}

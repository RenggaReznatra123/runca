import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit() : super(OnboardingInitial());

  static const Duration _loadingDuration = Duration(seconds: 3);

  Timer? _timer;

  /// Shows loading, then asks the screen to continue to login.
  void getStarted() {
    if (state is OnboardingLoading) return;
    emit(OnboardingLoading());
    _timer = Timer(_loadingDuration, () => emit(OnboardingCompleted()));
  }

  /// Skips the loading and continues to login right away.
  void skipToLogin() {
    _timer?.cancel();
    emit(OnboardingCompleted());
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}

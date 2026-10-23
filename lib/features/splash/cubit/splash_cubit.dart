import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(SplashInitial());

  static const Duration _splashDuration = Duration(seconds: 3);

  Timer? _timer;

  void start() {
    _timer?.cancel();
    _timer = Timer(_splashDuration, () => emit(SplashCompleted()));
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}

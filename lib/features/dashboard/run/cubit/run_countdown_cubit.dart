import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'run_countdown_state.dart';

class RunCountdownCubit extends Cubit<RunCountdownState> {
  RunCountdownCubit({int seconds = defaultSeconds})
    : super(RunCountdownState(remaining: seconds)) {
    _start();
  }

  static const int defaultSeconds = 3;

  Timer? _timer;

  void _start() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final next = state.remaining - 1;

      if (next <= 0) {
        timer.cancel();
        emit(const RunCountdownState(remaining: 0, finished: true));
        return;
      }

      emit(RunCountdownState(remaining: next));
    });
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}

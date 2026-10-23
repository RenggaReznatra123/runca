import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'success_state.dart';

class SuccessCubit extends Cubit<SuccessState> {
  SuccessCubit() : super(SuccessInitial());

  static const Duration _displayDuration = Duration(seconds: 3);

  Timer? _timer;

  void start() {
    _timer?.cancel();

    _timer = Timer(_displayDuration, () {
      if (!isClosed) {
        emit(SuccessCompleted());
      }
    });
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}

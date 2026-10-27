import '../models/reward_model.dart';

enum HowToEarnStatus { loading, success, failure }

class HowToEarnState {
  const HowToEarnState({
    this.status = HowToEarnStatus.loading,
    this.methods = const [],
  });

  final HowToEarnStatus status;
  final List<EarnMethod> methods;

  HowToEarnState copyWith({
    HowToEarnStatus? status,
    List<EarnMethod>? methods,
  }) {
    return HowToEarnState(
      status: status ?? this.status,
      methods: methods ?? this.methods,
    );
  }
}

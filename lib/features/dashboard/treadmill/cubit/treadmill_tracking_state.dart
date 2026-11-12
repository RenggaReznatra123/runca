enum TreadmillTrackingStatus { running, paused, finished }

class TreadmillTrackingState {
  const TreadmillTrackingState({
    this.status = TreadmillTrackingStatus.running,
    this.durationSeconds = 0,
    this.steps = 0,
    this.isLocked = false,
  });

  final TreadmillTrackingStatus status;
  final int durationSeconds;
  final int steps;

  /// True kalau layar dikunci.
  final bool isLocked;

  TreadmillTrackingState copyWith({
    TreadmillTrackingStatus? status,
    int? durationSeconds,
    int? steps,
    bool? isLocked,
  }) {
    return TreadmillTrackingState(
      status: status ?? this.status,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      steps: steps ?? this.steps,
      isLocked: isLocked ?? this.isLocked,
    );
  }
}

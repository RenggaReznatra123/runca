import '../models/challenge_model.dart';

enum ChallengeDetailStatus { loading, success, failure }

class ChallengeDetailState {
  const ChallengeDetailState({
    this.status = ChallengeDetailStatus.loading,
    this.detail,
  });

  final ChallengeDetailStatus status;
  final ChallengeDetail? detail;

  ChallengeDetailState copyWith({
    ChallengeDetailStatus? status,
    ChallengeDetail? detail,
  }) {
    return ChallengeDetailState(
      status: status ?? this.status,
      detail: detail ?? this.detail,
    );
  }
}

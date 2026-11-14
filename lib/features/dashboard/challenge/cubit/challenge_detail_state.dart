import '../models/challenge_model.dart';

enum ChallengeDetailStatus { loading, success, failure }

class ChallengeDetailState {
  const ChallengeDetailState({
    this.status = ChallengeDetailStatus.loading,
    this.detail,
    this.hasRefreshError = false,
  });

  final ChallengeDetailStatus status;
  final ChallengeDetail? detail;
  final bool hasRefreshError;

  ChallengeDetailState copyWith({
    ChallengeDetailStatus? status,
    ChallengeDetail? detail,
    bool? hasRefreshError,
  }) {
    return ChallengeDetailState(
      status: status ?? this.status,
      detail: detail ?? this.detail,
      hasRefreshError: hasRefreshError ?? this.hasRefreshError,
    );
  }
}

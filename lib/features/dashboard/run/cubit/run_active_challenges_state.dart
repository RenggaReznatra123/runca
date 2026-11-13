import 'package:runca/features/dashboard/challenge/models/challenge_progress.dart';

enum RunActiveChallengesStatus { loading, success, failure }

class RunActiveChallengesState {
  const RunActiveChallengesState({
    this.status = RunActiveChallengesStatus.loading,
    this.challenges = const [],
  });

  final RunActiveChallengesStatus status;
  final List<ChallengeProgress> challenges;

  RunActiveChallengesState copyWith({
    RunActiveChallengesStatus? status,
    List<ChallengeProgress>? challenges,
  }) {
    return RunActiveChallengesState(
      status: status ?? this.status,
      challenges: challenges ?? this.challenges,
    );
  }
}
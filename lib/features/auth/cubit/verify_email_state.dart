part of 'verify_email_cubit.dart';

enum VerifyEmailStatus { initial, verifying, success, failure }

@immutable
class VerifyEmailState extends Equatable {
  const VerifyEmailState({
    required this.secondsLeft,
    this.status = VerifyEmailStatus.initial,
    this.errorMessage,
  });

  final int secondsLeft;
  final VerifyEmailStatus status;
  final String? errorMessage;

  bool get isExpired => secondsLeft <= 0;

  VerifyEmailState copyWith({
    int? secondsLeft,
    VerifyEmailStatus? status,
    String? errorMessage,
    bool clearError = false,
  }) {
    return VerifyEmailState(
      secondsLeft: secondsLeft ?? this.secondsLeft,
      status: status ?? this.status,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [secondsLeft, status, errorMessage];
}
import 'package:equatable/equatable.dart';

enum ProfileSetupStatus { initial, loading, success, failure }

class ProfileSetupState extends Equatable {
  const ProfileSetupState({
    this.status = ProfileSetupStatus.initial,
    this.errorMessage,
  });

  final ProfileSetupStatus status;
  final String? errorMessage;

  ProfileSetupState copyWith({
    ProfileSetupStatus? status,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ProfileSetupState(
      status: status ?? this.status,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage];
}

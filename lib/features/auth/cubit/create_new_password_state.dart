import 'package:equatable/equatable.dart';

enum CreateNewPasswordStatus { initial, loading, success, failure }

class CreateNewPasswordState extends Equatable {
  const CreateNewPasswordState({
    this.status = CreateNewPasswordStatus.initial,
    this.errorMessage,
  });

  final CreateNewPasswordStatus status;
  final String? errorMessage;

  CreateNewPasswordState copyWith({
    CreateNewPasswordStatus? status,
    String? errorMessage,
  }) {
    return CreateNewPasswordState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage];
}

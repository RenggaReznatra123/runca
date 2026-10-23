part of 'sign_up_cubit.dart';

@immutable
sealed class SignUpState {}

final class SignUpInitial extends SignUpState {}

final class SignUpStateLoading extends SignUpState {}

final class SignUpStateSuccess extends SignUpState {}

final class SignUpStateError extends SignUpState {
  final String message;

  SignUpStateError({required this.message});
}

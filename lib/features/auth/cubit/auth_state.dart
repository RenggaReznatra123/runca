part of 'auth_cubit.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class AuthStateLoading extends AuthState {}

final class AuthStateSuccess extends AuthState {
  final UserModel? user;
  final String? accessToken;
  final bool isDirector;

  AuthStateSuccess({this.user, this.accessToken, required this.isDirector});
}

final class AuthStateError extends AuthState {
  final String message;

  AuthStateError({required this.message});
}

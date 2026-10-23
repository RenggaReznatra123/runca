part of 'success_cubit.dart';

@immutable
sealed class SuccessState {}

final class SuccessInitial extends SuccessState {}

final class SuccessCompleted extends SuccessState {}
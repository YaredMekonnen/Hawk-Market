part of 'sign_up_bloc.dart';

@immutable
sealed class SignUpState {}

final class SignUpInitial extends SignUpState {}

final class SigningUp extends SignUpState {}

final class SignUpSuccess extends SignUpState {
  final String message;

  SignUpSuccess({required this.message});
}

final class SignUpFailed extends SignUpState {
  final String message;

  SignUpFailed({required this.message});
}
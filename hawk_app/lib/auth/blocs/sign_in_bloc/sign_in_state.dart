part of 'sign_in_bloc.dart';

@immutable
sealed class SignInState {}

class SignInIntial extends SignInState {}

class SigningIn extends SignInState {}

class SignInSuccess extends SignInState {
  final String message;

  SignInSuccess({required this.message});
}

class SignInFailed extends SignInState {
  final String message;

  SignInFailed({required this.message});
}
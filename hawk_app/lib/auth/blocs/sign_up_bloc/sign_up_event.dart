part of 'sign_up_bloc.dart';

@immutable
sealed class SignUpEvent {}

class SignUp extends SignUpEvent {
  final String email;
  final String password;
  final String name;

  SignUp({required this.email, required this.password, required this.name});
}

class SignOut extends SignUpEvent {}
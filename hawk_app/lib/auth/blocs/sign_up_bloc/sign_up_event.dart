part of 'sign_up_bloc.dart';

@immutable
sealed class SignUpEvent {}

class SignUp extends SignUpEvent {
  final String email;
  final String password;
  final String username;
  final XFile? image;

  SignUp(
      {required this.email,
      required this.password,
      required this.username,
      this.image});
}

class SignOut extends SignUpEvent {}

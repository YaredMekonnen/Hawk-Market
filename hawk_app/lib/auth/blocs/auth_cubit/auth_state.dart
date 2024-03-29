part of 'auth_cubit.dart';

@immutable
sealed class AuthState {}

class Authenticated extends AuthState {
  final String token;

  Authenticated({required this.token});
}

class Unauthenticated extends AuthState {}

class Authenticating extends AuthState {}
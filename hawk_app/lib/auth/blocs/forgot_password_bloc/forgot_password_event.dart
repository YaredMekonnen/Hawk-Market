part of 'forgot_password_bloc.dart';

@immutable
sealed class ForgotPasswordEvent {}

class ForgotPassword extends ForgotPasswordEvent {
  final String email;

  ForgotPassword({required this.email});
}

class VerifyOtp extends ForgotPasswordEvent {
  final String otp;

  VerifyOtp({required this.otp});
}

class ResetPassword extends ForgotPasswordEvent {
  final String password;

  ResetPassword({required this.password});
}
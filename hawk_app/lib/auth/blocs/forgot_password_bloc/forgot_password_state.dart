part of 'forgot_password_bloc.dart';

@immutable
sealed class ForgotPasswordState {}

class ForgotPasswordIntial extends ForgotPasswordState {}

class ForgotPasswordLoading extends ForgotPasswordState {}

class ForgotPasswordSuccess extends ForgotPasswordState {
  final String message;

  ForgotPasswordSuccess({required this.message});
}

class ForgotPasswordFailed extends ForgotPasswordState {
  final String message;

  ForgotPasswordFailed({required this.message});
}

class VerifyOtpLoading extends ForgotPasswordState {}

class VerifyOtpSuccess extends ForgotPasswordState {
  final String message;

  VerifyOtpSuccess({required this.message});
}

class VerifyOtpFailed extends ForgotPasswordState {
  final String message;

  VerifyOtpFailed({required this.message});
}

class ResetPasswordLoading extends ForgotPasswordState {}

class ResetPasswordSuccess extends ForgotPasswordState {
  final String message;

  ResetPasswordSuccess({required this.message});
}

class ResetPasswordFailed extends ForgotPasswordState {
  final String message;

  ResetPasswordFailed({required this.message});
}
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hawk_app/auth/repository/auth.repository.dart';
import 'package:hawk_app/commons/utils/response.dart';
import 'package:meta/meta.dart';

part 'forgot_password_event.dart';
part 'forgot_password_state.dart';

class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  final AuthRepository repository;
  late String email = 'leulabay1@gmail.com';
  late String otp;

  ForgotPasswordBloc(this.repository) : super(ForgotPasswordIntial()) {
    on<ForgotPassword>(handleForgotPassword);
    on<VerifyOtp>(handleVerifyOtp);
    on<ResetPassword>(handleResetPassword);
  }

  handleForgotPassword(ForgotPassword event, emit) async {
    emit(ForgotPasswordLoading());

    final Result result =
        await repository.forgotPassword({"email": event.email});

    if (result is Success) {
      email = event.email;
      emit(ForgotPasswordSuccess(
          message: "An OTP has been sent to your email."));
    } else {
      emit(ForgotPasswordFailed(message: "Faild to intialize reset process"));
    }
  }

  handleVerifyOtp(VerifyOtp event, emit) async {
    emit(VerifyOtpLoading());

    final Result result = await repository.verifyOtp({
      "email": email,
      "otp": event.otp,
    });

    if (result is Success) {
      otp = event.otp;
      emit(VerifyOtpSuccess(message: "Otp verified successfully"));
    } else {
      emit(VerifyOtpFailed(message: "Otp verification failed"));
    }
  }

  handleResetPassword(ResetPassword event, emit) async {
    emit(ResetPasswordLoading());

    final Result result = await repository.resetPassword({
      "email": email,
      "otp": otp,
      "password": event.password,
    });

    if (result is Success) {
      emit(ResetPasswordSuccess(message: "Password reseted successfully"));
    } else {
      emit(ResetPasswordFailed(message: "Password reseting failed"));
    }
  }
}

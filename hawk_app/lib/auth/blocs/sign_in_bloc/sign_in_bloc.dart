import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hawk_app/auth/repository/auth.repository.dart';
import 'package:hawk_app/commons/utils/response.dart';
import 'package:meta/meta.dart';

part 'sign_in_event.dart';
part 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final AuthRepository authRepository;

  SignInBloc(this.authRepository) : super(SignInIntial()) {
    on<SignIn>(handleSignIn);
  }

  handleSignIn(event, emit) async {
    emit(SigningIn());

    final Result result = await authRepository
        .loginUser({'email': event.email, 'password': event.password});

    if (result is Success) {
      await authRepository.setToken(result.value['data']);
      emit(SignInSuccess(message: 'users signed in successfully'));
    } else {
      emit(SignInFailed(message: 'Failed to sign in. Please try again.'));
    }
  }
}

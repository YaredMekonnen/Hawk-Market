import 'package:bloc/bloc.dart';
import 'package:hawk_app/auth/repository/auth.repository.dart';
import 'package:hawk_app/commons/utils/response.dart';
import 'package:meta/meta.dart';

part 'sign_up_event.dart';
part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final AuthRepository authRepository;

  SignUpBloc(this.authRepository) : super(SignUpInitial()) {
    on<SignUpEvent>(handleSignUp);
  }

  handleSignUp(event, emit) async {
    emit(SigningUp());

    final result = await this.authRepository.registerUser({
      'email': event.email,
      'password': event.password,
      'name': event.name,
    });

    if (result is Success) {
      emit(SignUpSuccess(message: 'users signed up successfully'));
    } else {
      emit(SignUpFailed(message: 'Failed to sign up. Please try again.'));
    }
  }
}

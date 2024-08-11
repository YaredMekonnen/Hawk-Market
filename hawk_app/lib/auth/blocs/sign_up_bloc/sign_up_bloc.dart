import 'package:bloc/bloc.dart';
import 'package:hawk_app/auth/repository/auth.repository.dart';
import 'package:hawk_app/commons/utils/response.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';

part 'sign_up_event.dart';
part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final AuthRepository authRepository;

  SignUpBloc(this.authRepository) : super(SignUpInitial()) {
    on<SignUp>(handleSignUp);
    on<CloseSignUp>((event, emit) {
      emit(SignUpInitial());
    });
  }

  handleSignUp(SignUp event, emit) async {
    emit(SigningUp());

    final result = await this.authRepository.registerUser(
        email: event.email,
        password: event.password,
        username: event.username,
        image: event.image);

    if (result is Success) {
      emit(SignUpSuccess(message: 'users signed up successfully'));
    } else {
      emit(SignUpFailed(message: 'Failed to sign up. Please try again.'));
    }
  }
}

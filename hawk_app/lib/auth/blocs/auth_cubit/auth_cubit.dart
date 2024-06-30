import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hawk_app/auth/repository/auth.repository.dart';
import 'package:hawk_app/commons/utils/response.dart';
import 'package:meta/meta.dart';
import 'package:hawk_app/auth/models/user.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository authRepository;
  String token = '';
  User? user;

  AuthCubit(this.authRepository) : super(Authenticating());

  void checkAuthentication() async {
    emit(Authenticating());
    final String? bearerToken = await authRepository.checkAuthentication();
    if (bearerToken != null) {
      token = bearerToken;
      Result result = await authRepository.getUser();

      if (result is Success) {
        user = User.fromJson(result.value['data']);
        emit(Authenticated(token: bearerToken));
      } else {
        emit(Unauthenticated());
      }
    } else {
      emit(Unauthenticated());
    }
  }

  void logout() async {
    await authRepository.removeToken();
    emit(Unauthenticated());
  }
}

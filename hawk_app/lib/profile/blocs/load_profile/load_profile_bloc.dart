import 'package:bloc/bloc.dart';
import 'package:hawk_app/auth/models/user.dart';
import 'package:hawk_app/commons/utils/response.dart';
import 'package:hawk_app/profile/repository/profile.repository.dart';
import 'package:meta/meta.dart';

part 'load_profile_event.dart';
part 'load_profile_state.dart';

class LoadProfileBloc extends Bloc<LoadProfileEvent, LoadProfileState> {
  final ProfileRepository repository;

  LoadProfileBloc(this.repository) : super(LoadProfilenitial()) {
    on<LoadProfile>(loadProfile);
  }

  loadProfile(LoadProfile event, emit) async {
    emit(ProfileLoading());

    final Result result = await repository.getProfile(userId: event.userId);

    if (result is Success) {
      emit(ProfileLoaded(
          User.fromJson(result.value['data'] as Map<String, dynamic>)));
    } else {
      emit(ProfileLoadingError());
    }
  }
}

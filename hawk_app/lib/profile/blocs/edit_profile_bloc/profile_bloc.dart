import 'package:bloc/bloc.dart';
import 'package:hawk_app/auth/models/user.dart';
import 'package:hawk_app/commons/utils/response.dart';
import 'package:hawk_app/profile/repository/profile.repository.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class UpdateProfileBloc extends Bloc<UpdateProfileEvent, UpdateProfileState> {
  final ProfileRepository repository;

  UpdateProfileBloc(this.repository) : super(UpdateProfileInitial()) {
    on<UpdateProfile>(updateProfile);
  }

  updateProfile(UpdateProfile event, emit) async {
    emit(UpdateProfileLoading());

    final Result result = await repository.updateProfile(
        id: event.id,
        username: event.username,
        bio: event.bio,
        image: event.image);

    if (result is Success) {
      emit(UpdateProfileSuccess(
          User.fromJson(result.value['data'] as Map<String, dynamic>)));
    } else {
      emit(UpdateProfileFailure());
    }
  }
}

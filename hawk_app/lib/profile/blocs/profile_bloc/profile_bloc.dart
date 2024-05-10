import 'package:bloc/bloc.dart';
import 'package:chopper/chopper.dart';
import 'package:hawk_app/auth/models/user.dart';
import 'package:hawk_app/commons/utils/response.dart';
import 'package:hawk_app/profile/repository/profile.repository.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {

  final ProfileRepository repository;

  ProfileBloc(this.repository) : super(ProfileInitial()) {
    on<UpdateProfile>(updateProfile);
  }

  updateProfile(UpdateProfile event, emit) async {
    emit(ProfileLoading());

    final Result result = await this.repository.updateProfile(
      id: event.id,
      firstName: event.firstName,
      lastName: event.lastName,
      bio: event.bio,
      image: event.image
    );

    if (result is Success) {
      emit(ProfileSuccess(User.fromJson(result.value as Map<String, dynamic>)));
    } else {
      emit(ProfileFailure());
    }
  }

  bookmark(Bookmark event, emit) async {

    final Result result = await this.repository.bookmark(
      userId: event.userId,
      productId: event.productId
    );

    if (result is Success) {
      emit(BookmarkSuccess());
    } else {
      emit(BookmarkFailure());
    }
  }
}

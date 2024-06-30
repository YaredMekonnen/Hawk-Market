part of 'profile_bloc.dart';

@immutable
sealed class UpdateProfileEvent {}

final class UpdateProfile extends UpdateProfileEvent {
  final String id;
  final String username;
  final String bio;
  final XFile? image;

  UpdateProfile({
    required this.id,
    required this.username,
    required this.bio,
    this.image,
  });
}

part of 'profile_bloc.dart';

@immutable
sealed class ProfileEvent {}

final class UpdateProfile extends ProfileEvent {
  final String id;
  final String firstName;
  final String lastName;
  final String bio;
  XFile? image;

  UpdateProfile({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.bio,
    this.image,
  });
}

final class Bookmark extends ProfileEvent {
  final String userId;
  final String productId;

  Bookmark({
    required this.userId,
    required this.productId,
  });
}
part of 'profile_bloc.dart';

@immutable
sealed class UpdateProfileState {}

final class UpdateProfileInitial extends UpdateProfileState {}

final class UpdateProfileLoading extends UpdateProfileState {}

final class UpdateProfileSuccess extends UpdateProfileState {
  final User profile;

  UpdateProfileSuccess(this.profile);
}

final class UpdateProfileFailure extends UpdateProfileState {}

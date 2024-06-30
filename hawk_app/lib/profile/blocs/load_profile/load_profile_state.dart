part of 'load_profile_bloc.dart';

@immutable
sealed class LoadProfileState {}

final class LoadProfilenitial extends LoadProfileState {}

final class ProfileLoading extends LoadProfileState {}

final class ProfileLoaded extends LoadProfileState {
  final User user;

  ProfileLoaded(this.user);
}

final class ProfileLoadingError extends LoadProfileState {}

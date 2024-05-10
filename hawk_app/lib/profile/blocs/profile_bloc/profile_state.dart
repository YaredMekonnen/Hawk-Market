part of 'profile_bloc.dart';

@immutable
sealed class ProfileState {}

final class ProfileInitial extends ProfileState {}

final class ProfileLoading extends ProfileState {}

final class ProfileSuccess extends ProfileState {
  final User profile;

  ProfileSuccess(this.profile);
}

final class ProfileFailure extends ProfileState {}

final class BookmarkSuccess extends ProfileState {}

final class BookmarkFailure extends ProfileState {}

final class BookmarkLoading extends ProfileState {}
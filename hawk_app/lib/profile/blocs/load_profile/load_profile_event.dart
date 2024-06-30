part of 'load_profile_bloc.dart';

@immutable
sealed class LoadProfileEvent {}

final class LoadProfile extends LoadProfileEvent {
  final String userId;

  LoadProfile(this.userId);
}

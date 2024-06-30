part of 'load_user_story_bloc.dart';

@immutable
sealed class LoadUserStoryState {}

final class LoadUserStroyInitial extends LoadUserStoryState {}

final class UserStoriesLoading extends LoadUserStoryState {}

final class UserStoriesLoaded extends LoadUserStoryState {
  final List<Story> stories;

  UserStoriesLoaded(this.stories);
}

final class UserStoryLoadingError extends LoadUserStoryState {}

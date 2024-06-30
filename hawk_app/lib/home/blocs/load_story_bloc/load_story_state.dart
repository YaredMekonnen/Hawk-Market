part of 'load_story_bloc.dart';

@immutable
sealed class LoadStoryState {}

final class LoadStroyInitial extends LoadStoryState {}

final class StoriesLoading extends LoadStoryState {}

final class StoriesLoaded extends LoadStoryState {
  StoriesLoaded();
}

final class StoryLoadingError extends LoadStoryState {}

final class MoreStoriesLoading extends LoadStoryState {}

final class MoreStoriesLoaded extends LoadStoryState {
  MoreStoriesLoaded();
}

final class MoreStoryLoadingError extends LoadStoryState {}

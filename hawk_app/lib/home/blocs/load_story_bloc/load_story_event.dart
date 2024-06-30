part of 'load_story_bloc.dart';

@immutable
sealed class LoadStoryEvent {}

final class LoadStories extends LoadStoryEvent {
  final int skip;
  final int limit;

  LoadStories(this.skip, this.limit);
}

final class LoadMoreStories extends LoadStoryEvent {
}

final class MakeStory extends LoadStoryEvent {
  final String storyId;

  MakeStory(this.storyId);
}

part of 'load_user_story_bloc.dart';

@immutable
sealed class LoadUserStoryEvent {}

final class LoadUserStories extends LoadUserStoryEvent {
  final String userId;
  final int skip;
  final int limit;

  LoadUserStories(this.userId, this.skip, this.limit);
}

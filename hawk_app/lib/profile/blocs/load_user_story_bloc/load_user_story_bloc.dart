import 'package:bloc/bloc.dart';
import 'package:hawk_app/commons/utils/response.dart';
import 'package:hawk_app/home/models/story.dart';
import 'package:hawk_app/home/repository/story.repository.dart';
import 'package:hawk_app/profile/repository/profile.repository.dart';
import 'package:meta/meta.dart';

part 'load_user_story_event.dart';
part 'load_user_story_state.dart';

class LoadUserStoryBloc extends Bloc<LoadUserStoryEvent, LoadUserStoryState> {
  final StoryRepository repository;

  LoadUserStoryBloc(this.repository) : super(LoadUserStroyInitial()) {
    on<LoadUserStories>(loadUserStories);
  }

  loadUserStories(LoadUserStories event, emit) async {
    emit(UserStoriesLoading());

    final Result result = await repository.getUserStories(
        userId: event.userId, skip: event.skip, limit: event.limit);

    if (result is Success) {
      emit(UserStoriesLoaded((result.value['data'] as List)
          .map((e) => Story.fromJson(e as Map<String, dynamic>))
          .toList()));
    } else {
      emit(UserStoryLoadingError());
    }
  }
}

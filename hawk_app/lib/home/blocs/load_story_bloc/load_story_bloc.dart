import 'package:bloc/bloc.dart';
import 'package:hawk_app/commons/utils/response.dart';
import 'package:hawk_app/home/models/story.dart';
import 'package:hawk_app/home/repository/story.repository.dart';
import 'package:meta/meta.dart';

part 'load_story_event.dart';
part 'load_story_state.dart';

class LoadStoryBloc extends Bloc<LoadStoryEvent, LoadStoryState> {
  final StoryRepository repository;
  final List<Story> stories = [];

  LoadStoryBloc(this.repository) : super(LoadStroyInitial()) {
    on<LoadStories>(loadStories);
    on<LoadMoreStories>(loadMoreStories);

    on<MakeStory>((event, emit) async {
      Result result = await repository.makeStory(id: event.storyId);
      if (result is Success) {
        add(LoadStories(0, 10));
      }
    });
  }

  loadStories(LoadStories event, emit) async {
    emit(StoriesLoading());
    stories.clear();

    final Result result =
        await repository.getStories(skip: event.skip, limit: event.limit);

    if (result is Success) {
      stories.addAll((result.value['data'] as List)
          .map((e) => Story.fromJson(e as Map<String, dynamic>))
          .toList());
      emit(StoriesLoaded());
    } else {
      emit(StoryLoadingError());
    }
  }

  loadMoreStories(LoadMoreStories event, emit) async {
    if (state is MoreStoriesLoading || state is StoriesLoading) return;
    emit(MoreStoriesLoading());

    final Result result =
        await repository.getStories(skip: stories.length, limit: 10);

    if (result is Success) {
      stories.addAll((result.value['data'] as List)
          .map((e) => Story.fromJson(e as Map<String, dynamic>))
          .toList());
      emit(MoreStoriesLoaded());
    } else {
      emit(MoreStoryLoadingError());
    }
  }
}

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'post_list_event.dart';
part 'post_list_state.dart';

class PostListBloc extends Bloc<PostListEvent, PostListState> {
  PostListBloc() : super(PostListInitial()) {
    on<PostListEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}

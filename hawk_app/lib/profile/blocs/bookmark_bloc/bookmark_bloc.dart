import 'package:bloc/bloc.dart';
import 'package:chopper/chopper.dart';
import 'package:hawk_app/auth/models/user.dart';
import 'package:hawk_app/commons/utils/response.dart';
import 'package:hawk_app/create_product/models/product.dart';
import 'package:hawk_app/profile/repository/profile.repository.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';

part 'bookmark_event.dart';
part 'bookmark_state.dart';

class BookmarkBloc extends Bloc<BookmarkEvent, BookmarkState> {

  final ProfileRepository repository;

  BookmarkBloc(this.repository) : super(BookmarkInitial()) {
    on<LoadBookmark>(loadBookmark);
  }

  loadBookmark(LoadBookmark event, emit) async {
    emit(BookmarkLoading());

    final Result result = await this.repository.getBookmarks(userId: event.userId, page: event.page, limit: event.limit);

    if (result is Success) {
      emit(BookmarkLoaded((result.value as List).map((e) => Product.fromJson(e as Map<String, dynamic>)).toList()));
    } else {
      emit(BookmarkError());
    }
  }
}

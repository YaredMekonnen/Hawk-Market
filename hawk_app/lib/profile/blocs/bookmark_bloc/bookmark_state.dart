part of 'bookmark_bloc.dart';

@immutable
sealed class BookmarkState {}

final class BookmarkInitial extends BookmarkState {}

final class BookmarkLoading extends BookmarkState {}

final class BookmarkLoaded extends BookmarkState {
  final List<Product> bookmarks;

  BookmarkLoaded(this.bookmarks);
}

final class BookmarkError extends BookmarkState {
}
part of 'bookmark_bloc.dart';

@immutable
sealed class BookmarkEvent {}

final class LoadBookmark extends BookmarkEvent {
  final String userId;
  final int page;
  final int limit;

  LoadBookmark(this.userId, this.page, this.limit);
}
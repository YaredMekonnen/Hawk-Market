part of 'bookmark_bloc.dart';

@immutable
sealed class BookmarkEvent {}

final class LoadBookmark extends BookmarkEvent {
  final String userId;
  final int skip;
  final int limit;

  LoadBookmark(this.userId, this.skip, this.limit);
}

final class BookmarkProduct extends BookmarkEvent {
  final String productId;

  BookmarkProduct(this.productId);
}

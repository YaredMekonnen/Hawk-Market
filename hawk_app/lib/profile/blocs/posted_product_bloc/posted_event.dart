part of 'posted_bloc.dart';

@immutable
sealed class PostedEvent {}

final class LoadPosted extends PostedEvent {
  final String userId;
  final int skip;
  final int limit;

  LoadPosted(this.userId, this.skip, this.limit);
}

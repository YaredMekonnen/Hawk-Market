part of 'messages_bloc.dart';

@immutable
sealed class MessagesState {}

final class MessagesInitial extends MessagesState {}

final class MessageLoading extends MessagesState {}

final class ImageMessageLoading extends MessagesState {}

final class ImageMessageLoaded extends MessagesState {
  final List<Message> messages;

  ImageMessageLoaded(this.messages);
}

final class MessageLoadingFaild extends MessagesState {
  final String message;

  MessageLoadingFaild(this.message);
}

final class MoreMessageLoading extends MessagesState {}

final class MessageLoaded extends MessagesState {}

final class MoreMessageLoadingFailed extends MessagesState {
  final String message;

  MoreMessageLoadingFailed(this.message);
}

part of 'chat_bloc.dart';

@immutable
sealed class ChatState {}

final class ChatInitial extends ChatState {}

final class ChatLoading extends ChatState {}

final class ChatError extends ChatState {
  final String message;

  ChatError(this.message);
}

final class NewChatLoaded extends ChatState {
  final User otherOwner;

  NewChatLoaded(this.otherOwner);
}

final class ChatLoaded extends ChatState {
  final Chat chat;
  final User otherOwner;

  ChatLoaded(this.chat, this.otherOwner);
}

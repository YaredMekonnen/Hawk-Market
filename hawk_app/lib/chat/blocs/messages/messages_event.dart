part of 'messages_bloc.dart';

@immutable
sealed class MessagesEvent {}

class LoadMessages extends MessagesEvent {
  final String chatId;
  final int skip;
  final int limit;
  final String userId;

  LoadMessages(
      {required this.chatId,
      required this.userId,
      this.skip = 0,
      this.limit = 10});
}

class LoadMoreMessages extends MessagesEvent {
  final int limit;
  final String userId;

  LoadMoreMessages({required this.userId, this.limit = 10});
}

class UpdateMessages extends MessagesEvent {
  final List<Message> messages;

  UpdateMessages(this.messages);
}

class SendMessage extends MessagesEvent {
  final Message message;

  SendMessage(this.message);
}

class MessageSent extends MessagesEvent {
  final Message message;

  MessageSent(this.message);
}

class MessageSendingFaild extends MessagesEvent {}

class SendImagesMessage extends MessagesEvent {
  final String senderId;
  final String chatId;
  final List<XFile> images;

  SendImagesMessage(
      {required this.senderId, required this.chatId, required this.images});
}

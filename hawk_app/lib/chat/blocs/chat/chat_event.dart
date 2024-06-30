part of 'chat_bloc.dart';

@immutable
sealed class ChatEvent {}

class LoadChat extends ChatEvent {
  final String chatId;
  final String userId;
  final String otherOwner;

  LoadChat(this.chatId, this.userId, this.otherOwner);
}

class LoadChatWithUserIds extends ChatEvent {
  final String userId;
  final String otherOwner;

  LoadChatWithUserIds(this.userId, this.otherOwner);
}

class ChatCreated extends ChatEvent {
  final Chat chat;
  final User otherOwner;

  ChatCreated(this.chat, this.otherOwner);
}

class ChatCreationFaild extends ChatEvent {}

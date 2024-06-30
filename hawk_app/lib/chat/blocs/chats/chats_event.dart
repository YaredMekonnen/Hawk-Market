part of 'chats_bloc.dart';

@immutable
sealed class ChatsEvent {}

class LoadChats extends ChatsEvent {}

class UpdateChat extends ChatsEvent {
  final Chat chat;

  UpdateChat(this.chat);
}

part of 'chats_bloc.dart';

@immutable
sealed class ChatsState {}

final class ChatsInitial extends ChatsState {}

final class ChatsLoading extends ChatsState {}

final class ChatsLoaded extends ChatsState {
  final List<Chat> chats;

  ChatsLoaded(this.chats);
}

final class ChatsError extends ChatsState {
  final String message;

  ChatsError(this.message);
}

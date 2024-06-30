import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:hawk_app/auth/models/user.dart';
import 'package:hawk_app/chat/models/chat.dart';
import 'package:hawk_app/chat/repository/chats.repository.dart';
import 'package:hawk_app/commons/utils/response.dart';
import 'package:meta/meta.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository repository;
  String? chatId = '-1';

  ChatBloc(this.repository) : super(ChatInitial()) {
    on<LoadChat>((event, emit) async {
      emit(ChatLoading());
      chatId = event.chatId;
      Result result = await repository.getChat(event.chatId);

      if (result is Success) {
        Chat chat = Chat.fromJson(result.value['data']);
        User otherOwner =
            chat.owners.firstWhere((element) => event.otherOwner == element.id);
        emit(ChatLoaded(chat, otherOwner));
      } else {
        emit(ChatError("chat couldn't be loaded"));
      }
    });

    on<LoadChatWithUserIds>((event, emit) async {
      emit(ChatLoading());
      Result result = await repository.getChatWithUserId(event.otherOwner);

      if (result is Success) {
        if (result.value['status'] == false) {
          User otherOwner = User.fromJson(result.value['data']);
          emit(NewChatLoaded(otherOwner));
          return;
        }

        Chat chat = Chat.fromJson(result.value['data']);
        User otherOwner =
            chat.owners.firstWhere((element) => event.otherOwner == element.id);
        chatId = chat.id;
        emit(ChatLoaded(chat, otherOwner));
      } else {
        emit(ChatError("chat couldnt be loaded"));
      }
    });

    on<ChatCreated>((event, emit) {
      if (chatId == '-1') {
        chatId = event.chat.id;
        emit(ChatLoaded(event.chat, event.otherOwner));
      }
    });

    on<ChatCreationFaild>((event, emit) {
      emit(ChatError("chat couldnt be created"));
    });
  }
}

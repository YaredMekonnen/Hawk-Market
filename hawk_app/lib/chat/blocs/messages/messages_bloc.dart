import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:hawk_app/chat/models/message.dart';
import 'package:hawk_app/chat/repository/chats.repository.dart';
import 'package:hawk_app/commons/constants/message_type.dart';
import 'package:hawk_app/commons/utils/response.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';

part 'messages_event.dart';
part 'messages_state.dart';

class MessagesBloc extends Bloc<MessagesEvent, MessagesState> {
  final ChatRepository repository;

  List<Message> messages = [];
  String chatId = '-1';

  MessagesBloc(this.repository) : super(MessagesInitial()) {
    on<LoadMessages>((event, emit) async {
      emit(MessageLoading());
      chatId = event.chatId;

      Result result =
          await repository.getMessages(event.chatId, 0, event.limit);

      if (result is Success) {
        messages = (result.value['data'] as List)
            .map((e) => Message.fromJson(e))
            .toList();

        emit(MessageLoaded());
      } else {
        emit(MessageLoadingFaild("message couldnt be loaded"));
      }
    });

    on<LoadMoreMessages>((event, emit) async {
      if (chatId == '-1' ||
          state is MoreMessageLoading ||
          state is MessageLoading) return;

      emit(MoreMessageLoading());

      Result result =
          await repository.getMessages(chatId, messages.length, event.limit);

      if (result is Success) {
        messages.addAll((result.value['data'] as List)
            .map((e) => Message.fromJson(e))
            .toList());

        emit(MessageLoaded());
      } else {
        emit(MoreMessageLoadingFailed("message couldnt be loaded"));
      }
    });

    on<UpdateMessages>((event, emit) {
      if (chatId == '-1' ||
          (chatId != '-1' && event.messages[0].chatId != chatId)) {
        return;
      }
      for (var message in event.messages) {
        messages.insert(0, message);
      }
      emit(MessageLoaded());
    });

    on<SendMessage>((event, emit) {
      if (chatId == '-1' ||
          (chatId != '-1' && event.message.chatId != chatId)) {
        return;
      }

      messages.insert(0, event.message);
      emit(MessageLoaded());
    });

    on<MessageSent>((event, emit) {
      if (chatId == '-1' ||
          (chatId != '-1' && event.message.chatId != chatId)) {
        return;
      }

      messages.removeWhere((element) => element.id == "-1");
      messages.insert(0, event.message);
      emit(MessageLoaded());
    });

    on<MessageSendingFaild>((event, emit) {
      if (chatId == '-1') return;

      messages.removeWhere((element) => element.id == "-1");
      emit(MessageLoaded());
    });

    on<SendImagesMessage>((event, emit) async {
      emit(ImageMessageLoading());

      final Result result = await repository.SendImagesMessage(
          chatId: event.chatId, images: event.images, senderId: event.senderId);

      if (result is Success) {
        var messages = (result.value['data'] as List)
            .map((e) => Message.fromJson(e))
            .toList();
        for (var message in messages) {
          this.messages.insert(0, message);
        }

        emit(ImageMessageLoaded(messages));
      } else {
        emit(MessageLoaded());
      }
    });
  }
}

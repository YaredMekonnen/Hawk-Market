import 'package:bloc/bloc.dart';
import 'package:hawk_app/chat/models/chat.dart';
import 'package:hawk_app/chat/repository/chats.repository.dart';
import 'package:hawk_app/commons/utils/response.dart';
import 'package:meta/meta.dart';

part 'chats_event.dart';
part 'chats_state.dart';

class ChatsBloc extends Bloc<ChatsEvent, ChatsState> {
  Map<String, Chat> chatsMap = {};

  List<Chat> chats = [];

  final ChatRepository repository;

  ChatsBloc(this.repository) : super(ChatsInitial()) {
    on<LoadChats>((event, emit) async {
      emit(ChatsLoading());
      Result result = await repository.getChats();
      if (result is Success) {
        chats = result.value['data']
            .map((chat) {
              return Chat.fromJson(chat);
            })
            .toList()
            .cast<Chat>();
        // Sort chats by last message and the last message is always present on a chat.
        chats.sort((chat1, chat2) =>
            -1 *
            chat1.messages[0].createdAt.compareTo(chat2.messages[0].createdAt));

        chatsMap = {};
        for (var chat in chats) {
          chatsMap[chat.id] = chat;
        }
        ;

        emit(ChatsLoaded(chats));
      }
    });

    on<UpdateChat>((event, emit) {
      chatsMap[event.chat.id] = event.chat;
      chats = chatsMap.values.toList();
      chats.sort((chat1, chat2) =>
          -1 *
          chat1.messages[0].createdAt.compareTo(chat2.messages[0].createdAt));
      emit(ChatsLoaded(chats));
    });
  }
}

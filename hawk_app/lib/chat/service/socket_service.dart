import 'dart:convert';

import 'package:hawk_app/auth/blocs/auth_cubit/auth_cubit.dart';
import 'package:hawk_app/auth/models/user.dart';
import 'package:hawk_app/chat/blocs/chat/chat_bloc.dart';
import 'package:hawk_app/chat/blocs/chats/chats_bloc.dart';
import 'package:hawk_app/chat/blocs/messages/messages_bloc.dart';
import 'package:hawk_app/chat/models/chat.dart';
import 'package:hawk_app/chat/models/message.dart';
import 'package:hawk_app/commons/constants/api_endpoints.dart';
import 'package:hawk_app/commons/constants/message_type.dart';
import 'package:hawk_app/commons/constants/websocket_events.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  late IO.Socket socket;
  final ChatBloc chatBloc;
  final ChatsBloc chatsBloc;
  final MessagesBloc messagesBloc;
  final AuthCubit authCubit;

  SocketService(
      {required this.chatBloc,
      required this.chatsBloc,
      required this.messagesBloc,
      required this.authCubit}) {}

  void connect() {
    socket = IO.io(APIEndpoints.baseUrl,
        IO.OptionBuilder().setTransports(['websocket']).build());

    socket.onConnect((data) {
      socket.emit(
          WebsocketEvent.connected.name,
          jsonEncode({
            'userId': authCubit.user!.id,
          }));
    });

    socket.onDisconnect((data) {
      print("Disconnected");
    });

    socket.onReconnect((data) {
      print("Reconnected");
    });

    socket.on(WebsocketEvent.update_chat.name, (data) {
      try {
        Chat chat = Chat.fromJson(data['data']);
        chatsBloc.add(UpdateChat(chat));
      } catch (e) {
        print(e.toString());
      }
    });

    socket.on(WebsocketEvent.new_message.name, (data) {
      try {
        Message message = Message.fromJson(data['data']);
        messagesBloc.add(UpdateMessages([message]));
      } catch (e) {
        print(e.toString());
      }
    });

    socket.on(WebsocketEvent.new_messages.name, (data) {
      try {
        List<Message> messages =
            (data['data'] as List).map((e) => Message.fromJson(e)).toList();
        messagesBloc.add(UpdateMessages(messages));
      } catch (e) {
        print(e.toString());
      }
    });
  }

  void sendMessage({required String chatId, required String text}) {
    Message newMessage = Message(
        id: '-1',
        image: '',
        text: text,
        type: MessageType.text.name,
        senderId: authCubit.user!.id,
        chatId: chatId,
        createdAt: DateTime.now());

    messagesBloc.add(SendMessage(newMessage));

    socket.emitWithAckAsync(
        WebsocketEvent.new_message.name,
        json.encode({
          "chatId": chatId,
          "text": text,
          "senderId": authCubit.user?.id,
          "type": MessageType.text.name
        }), ack: (data) {
      try {
        messagesBloc.add(MessageSent(Message.fromJson(data['data'])));
      } catch (e) {
        MessageSendingFaild();
      }
    });
  }

  void sendImagesMessage(
      List<Message> messages, String reciverId, String chatId) {
    List<Map<String, dynamic>> data = messages.map((e) => e.toJson()).toList();
    socket.emit(
        WebsocketEvent.new_messages.name,
        jsonEncode(
            {"messages": data, "reciverId": reciverId, "chatId": chatId}));
  }

  void createChat({required String recieverId, required String text}) {
    Message newMessage = Message(
        id: '-1',
        image: '',
        text: text,
        type: MessageType.text.name,
        senderId: authCubit.user!.id,
        chatId: '-1',
        createdAt: DateTime.now());

    messagesBloc.add(SendMessage(newMessage));

    socket.emitWithAck(
        WebsocketEvent.new_chat.name,
        jsonEncode({
          "owners": [authCubit.user?.id, recieverId],
          "senderId": authCubit.user?.id,
          "text": text
        }), ack: (data) {
      try {
        Chat chat = Chat.fromJson(data['data']);
        User otherOnwer =
            chat.owners.firstWhere((element) => element.id == recieverId);

        chatBloc.add(ChatCreated(chat, otherOnwer));
        chatsBloc.add(UpdateChat(chat));
      } catch (e) {
        chatBloc.add(ChatCreationFaild());
      }
    });
  }

  void readMessage({required String chatId}) {
    socket.emit(WebsocketEvent.read_message.name,
        jsonEncode({"chatId": chatId, "userId": authCubit.user?.id}));
  }
}

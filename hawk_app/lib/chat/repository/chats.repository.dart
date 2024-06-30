import 'dart:io';

import 'package:chopper/chopper.dart';
import 'package:hawk_app/chat/blocs/messages/messages_bloc.dart';
import 'package:hawk_app/chat/service/chat_service.dart';
import 'package:hawk_app/commons/constants/message_type.dart';
import 'package:hawk_app/commons/utils/response.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart' show MultipartFile;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

class ChatRepository {
  final ChatChopperService chatService;
  ChatRepository(this.chatService);

  Future<Result<Map<String, dynamic>>> getChats() async {
    try {
      Response<Result<Map<String, dynamic>>> response =
          await chatService.getChats();
      if (response.isSuccessful) {
        return response.body as Result<Map<String, dynamic>>;
      } else {
        return Error(response.error as Map<String, dynamic>);
      }
    } catch (e) {
      return Error({"message": "Unexpected Error"});
    }
  }

  Future<Result<Map<String, dynamic>>> getChat(String chatId) async {
    try {
      Response<Result<Map<String, dynamic>>> response =
          await chatService.getChat(chatId: chatId);
      if (response.isSuccessful) {
        return response.body as Result<Map<String, dynamic>>;
      } else {
        return Error(response.error as Map<String, dynamic>);
      }
    } catch (e) {
      return Error({"message": "Unexpected Error"});
    }
  }

  Future<Result<Map<String, dynamic>>> getChatWithUserId(String userId) async {
    try {
      Response<Result<Map<String, dynamic>>> response =
          await chatService.getChatWithUserId(userId: userId);
      if (response.isSuccessful) {
        return response.body as Result<Map<String, dynamic>>;
      } else {
        return Error(response.error as Map<String, dynamic>);
      }
    } catch (e) {
      return Error({"message": "Unexpected Error"});
    }
  }

  Future<Result<Map<String, dynamic>>> getMessages(
      String chatId, int? skip, int? limit) async {
    try {
      Response<Result<Map<String, dynamic>>> response = await chatService
          .getChatMessages(chatId: chatId, skip: skip, limit: limit);
      if (response.isSuccessful) {
        return response.body as Result<Map<String, dynamic>>;
      } else {
        return Error(response.error as Map<String, dynamic>);
      }
    } catch (e) {
      return Error({"message": "Unexpected Error"});
    }
  }

  Future<Result<Map<String, dynamic>>> SendImagesMessage({
    required String chatId,
    required String senderId,
    required List<XFile> images,
  }) async {
    final List<MultipartFile> imageFiles = images.map((image) {
      return http.MultipartFile(
        'images',
        File(image.path).readAsBytes().asStream(),
        File(image.path).lengthSync(),
        filename: image.path.split('/').last,
        contentType: MediaType.parse(
          lookupMimeType(image.path) ?? '',
        ),
      );
    }).toList();

    try {
      final Response<Result<Map<String, dynamic>>> response =
          await chatService.sendImagesMessage(
        senderId: senderId,
        chatId: chatId,
        chatIdParam: chatId,
        type: MessageType.image.name,
        images: imageFiles,
      );

      if (response.isSuccessful) {
        return response.body as Result<Map<String, dynamic>>;
      } else {
        return Error(response.error as Map<String, dynamic>);
      }
    } catch (e) {
      return Error({"message": "Unexpected Error"});
    }
  }
}

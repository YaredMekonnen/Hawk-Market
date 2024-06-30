// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$ChatChopperService extends ChatChopperService {
  _$ChatChopperService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = ChatChopperService;

  @override
  Future<Response<Result<Map<String, dynamic>>>> createChat(
      Map<dynamic, String> data) {
    final Uri $url = Uri.parse('/chat');
    final $body = data;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client
        .send<Result<Map<String, dynamic>>, Map<String, dynamic>>($request);
  }

  @override
  Future<Response<Result<Map<String, dynamic>>>> getChats() {
    final Uri $url = Uri.parse('/chat');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client
        .send<Result<Map<String, dynamic>>, Map<String, dynamic>>($request);
  }

  @override
  Future<Response<Result<Map<String, dynamic>>>> getChat(
      {required String chatId}) {
    final Uri $url = Uri.parse('/chat/${chatId}');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client
        .send<Result<Map<String, dynamic>>, Map<String, dynamic>>($request);
  }

  @override
  Future<Response<Result<Map<String, dynamic>>>> getChatWithUserId(
      {required String userId}) {
    final Uri $url = Uri.parse('/chat/check/${userId}');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client
        .send<Result<Map<String, dynamic>>, Map<String, dynamic>>($request);
  }

  @override
  Future<Response<Result<Map<String, dynamic>>>> sendImagesMessage({
    required String senderId,
    required String chatId,
    required String type,
    required String chatIdParam,
    required List<MultipartFile> images,
  }) {
    final Uri $url = Uri.parse('/chat/${chatIdParam}/message');
    final Map<String, String> $headers = {
      'Accept': 'application/json',
      'Content-Type': 'multipart/form-data',
    };
    final List<PartValue> $parts = <PartValue>[
      PartValue<String>(
        'senderId',
        senderId,
      ),
      PartValue<String>(
        'chatId',
        chatId,
      ),
      PartValue<String>(
        'type',
        type,
      ),
      PartValueFile<List<MultipartFile>>(
        'images',
        images,
      ),
    ];
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parts: $parts,
      multipart: true,
      headers: $headers,
    );
    return client
        .send<Result<Map<String, dynamic>>, Map<String, dynamic>>($request);
  }

  @override
  Future<Response<Result<Map<String, dynamic>>>> getChatMessages({
    required String chatId,
    int? skip,
    int? limit,
  }) {
    final Uri $url = Uri.parse('/chat/${chatId}/message');
    final Map<String, dynamic> $params = <String, dynamic>{
      'skip': skip,
      'limit': limit,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client
        .send<Result<Map<String, dynamic>>, Map<String, dynamic>>($request);
  }
}

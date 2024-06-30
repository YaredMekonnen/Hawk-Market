import 'package:chopper/chopper.dart';
import 'package:hawk_app/commons/constants/api_endpoints.dart';
import 'package:hawk_app/commons/utils/response.dart';
import 'package:http/http.dart' show MultipartFile;

part 'chat_service.chopper.dart';

@ChopperApi()
abstract class ChatChopperService extends ChopperService {
  static ChatChopperService create({ChopperClient? client}) =>
      _$ChatChopperService(client);

  @Post(path: APIEndpoints.chat)
  Future<Response<Result<Map<String, dynamic>>>> createChat(
      @body Map<dynamic, String> data);

  @Get(path: APIEndpoints.chat)
  Future<Response<Result<Map<String, dynamic>>>> getChats();

  @Get(path: '${APIEndpoints.chat}/{id}')
  Future<Response<Result<Map<String, dynamic>>>> getChat({
    @Path("id") required String chatId,
  });

  @Get(path: '${APIEndpoints.chat}/check/{userId}')
  Future<Response<Result<Map<String, dynamic>>>> getChatWithUserId({
    @Path("userId") required String userId,
  });

  @Post(
    path: '${APIEndpoints.chat}/{chatId}/message',
    headers: {
      'Accept': 'application/json',
      'Content-Type': 'multipart/form-data', // <-- important
    },
  )
  @Multipart()
  Future<Response<Result<Map<String, dynamic>>>> sendImagesMessage({
    @Part('senderId') required String senderId,
    @Part('chatId') required String chatId,
    @Part('type') required String type,
    @Path('chatId') required String chatIdParam,
    @PartFile('images') required List<MultipartFile> images,
  });

  @Get(path: '${APIEndpoints.chat}/{chatId}/message')
  Future<Response<Result<Map<String, dynamic>>>> getChatMessages({
    @Path('chatId') required String chatId,
    @Query('skip') int? skip,
    @Query('limit') int? limit,
  });
}

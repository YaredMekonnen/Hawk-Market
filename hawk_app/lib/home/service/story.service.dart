import 'package:chopper/chopper.dart';
import 'package:hawk_app/commons/utils/response.dart';
import 'package:hawk_app/commons/constants/api_endpoints.dart';

part 'story.service.chopper.dart';

@ChopperApi()
abstract class StoryChooperService extends ChopperService {
  static StoryChooperService create({ChopperClient? client}) =>
      _$StoryChooperService(client);

  @Post(
    path: '${APIEndpoints.story}/{id}',
  )
  Future<Response<Result<Map<String, dynamic>>>> makeStory({
    @Path('id') required String productId,
    @Body() Map<String, dynamic> body = const {},
  });

  @Get(
    path: APIEndpoints.story,
  )
  Future<Response<Result<Map<String, dynamic>>>> getStories({
    @Query('skip') int? skip,
    @Query('limit') int? limit,
  });

  @Get(
    path: '${APIEndpoints.story}/{id}',
  )
  Future<Response<Result<Map<String, dynamic>>>> getUserStories({
    @Path('id') required String userId,
    @Query('skip') int? skip,
    @Query('limit') int? limit,
  });

  @Delete(
    path: '${APIEndpoints.story}/{id}',
  )
  Future<Response<Result<Map<String, dynamic>>>> deleteStory(
    @Path('id') String id,
  );
}

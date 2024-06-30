import 'package:chopper/chopper.dart';
import 'package:hawk_app/commons/utils/response.dart';
import 'package:hawk_app/home/service/story.service.dart';

class StoryRepository {
  StoryRepository(this.storyService);

  final StoryChooperService storyService;

  Future<Result<Map<String, dynamic>>> makeStory({
    required String id,
  }) async {
    try {
      final Response<Result<Map<String, dynamic>>> response =
          await storyService.makeStory(productId: id);
      if (response.isSuccessful) {
        return response.body as Result<Map<String, dynamic>>;
      } else {
        return Error(response.error as Map<String, dynamic>);
      }
    } catch (e) {
      return Error({"message": "Unexpected Error"});
    }
  }

  Future<Result<Map<String, dynamic>>> getUserStories({
    required String userId,
    required int skip,
    required int limit,
  }) async {
    try {
      final Response<Result<Map<String, dynamic>>> response =
          await storyService.getUserStories(
        userId: userId,
        skip: skip,
        limit: limit,
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

  Future<Result<Map<String, dynamic>>> getStories({
    required int skip,
    required int limit,
  }) async {
    try {
      final Response<Result<Map<String, dynamic>>> response =
          await storyService.getStories(
        skip: skip,
        limit: limit,
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

  Future<Result<Map<String, dynamic>>> deleteStory({
    required String id,
  }) async {
    try {
      final Response<Result<Map<String, dynamic>>> response =
          await storyService.deleteStory(
        id,
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

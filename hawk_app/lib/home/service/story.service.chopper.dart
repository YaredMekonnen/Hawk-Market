// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story.service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$StoryChooperService extends StoryChooperService {
  _$StoryChooperService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = StoryChooperService;

  @override
  Future<Response<Result<Map<String, dynamic>>>> makeStory({
    required String productId,
    Map<String, dynamic> body = const {},
  }) {
    final Uri $url = Uri.parse('/product/story/${productId}');
    final $body = body;
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
  Future<Response<Result<Map<String, dynamic>>>> getStories({
    int? skip,
    int? limit,
  }) {
    final Uri $url = Uri.parse('/product/story');
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

  @override
  Future<Response<Result<Map<String, dynamic>>>> getUserStories({
    required String userId,
    int? skip,
    int? limit,
  }) {
    final Uri $url = Uri.parse('/product/story/${userId}');
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

  @override
  Future<Response<Result<Map<String, dynamic>>>> deleteStory(String id) {
    final Uri $url = Uri.parse('/product/story/${id}');
    final Request $request = Request(
      'DELETE',
      $url,
      client.baseUrl,
    );
    return client
        .send<Result<Map<String, dynamic>>, Map<String, dynamic>>($request);
  }
}

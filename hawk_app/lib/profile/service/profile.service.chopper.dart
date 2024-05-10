// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile.service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$ProfileChooperService extends ProfileChooperService {
  _$ProfileChooperService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = ProfileChooperService;

  @override
  Future<Response<Result<Map<String, dynamic>>>> bookmark({
    required String productId,
    required String userId,
    required Map<String, dynamic> body,
  }) {
    final Uri $url = Uri.parse('/profilebookmark/${productId}/${userId}');
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
  Future<Response<Result<Map<String, dynamic>>>> updateProfile({
    required String id,
    required String firstName,
    required String lastName,
    required String bio,
    required MultipartFile? image,
  }) {
    final Uri $url = Uri.parse('/profile/${id}');
    final Map<String, String> $headers = {
      'Accept': 'application/json',
      'Content-Type': 'multipart/form-data',
    };
    final List<PartValue> $parts = <PartValue>[
      PartValue<String>(
        'firstName',
        firstName,
      ),
      PartValue<String>(
        'lastName',
        lastName,
      ),
      PartValue<String>(
        'bio',
        bio,
      ),
      PartValueFile<MultipartFile?>(
        'image',
        image,
      ),
    ];
    final Request $request = Request(
      'PUT',
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
  Future<Response<Result<Map<String, dynamic>>>> getBookmarks({
    required String userId,
    int? page,
    int? limit,
  }) {
    final Uri $url = Uri.parse('/profile/bookmark/${userId}');
    final Map<String, dynamic> $params = <String, dynamic>{
      'page': page,
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
  Future<Response<Result<Map<String, dynamic>>>> getProfile(String id) {
    final Uri $url = Uri.parse('/profile');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client
        .send<Result<Map<String, dynamic>>, Map<String, dynamic>>($request);
  }

  @override
  Future<Response<Result<Map<String, dynamic>>>> deleteProfile(String id) {
    final Uri $url = Uri.parse('/profile');
    final Request $request = Request(
      'DELETE',
      $url,
      client.baseUrl,
    );
    return client
        .send<Result<Map<String, dynamic>>, Map<String, dynamic>>($request);
  }
}

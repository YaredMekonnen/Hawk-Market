import 'dart:io';

import 'package:chopper/chopper.dart';
import 'package:hawk_app/commons/utils/response.dart';
import 'package:hawk_app/profile/service/profile.service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart' show MultipartFile;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

class ProfileRepository {
  ProfileRepository(this.ProfileService);

  final ProfileChooperService ProfileService;

  Future<Result<Map<String, dynamic>>> getProfile({
    required String userId,
  }) async {
    try {
      final Response<Result<Map<String, dynamic>>> response =
          await ProfileService.getProfile(
        userId,
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

  Future<Result<Map<String, dynamic>>> updateProfile({
    required String id,
    required String username,
    required String bio,
    XFile? image,
  }) async {
    final MultipartFile? imageFile = image != null
        ? http.MultipartFile(
            'image',
            File(image.path).readAsBytes().asStream(),
            File(image.path).lengthSync(),
            filename: image.path.split('/').last,
            contentType: MediaType.parse(
              lookupMimeType(image.path) ?? '',
            ),
          )
        : null;

    try {
      final Response<Result<Map<String, dynamic>>> response =
          await ProfileService.updateProfile(
        id: id,
        username: username,
        bio: bio,
        image: imageFile,
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

  Future<Result<Map<String, dynamic>>> bookmark({
    required String productId,
  }) async {
    try {
      final Response<Result<Map<String, dynamic>>> response =
          await ProfileService.bookmark(productId: productId, body: {});
      if (response.isSuccessful) {
        return response.body as Result<Map<String, dynamic>>;
      } else {
        return Error(response.error as Map<String, dynamic>);
      }
    } catch (e) {
      return Error({"message": "Unexpected Error"});
    }
  }

  Future<Result<Map<String, dynamic>>> getBookmarks({
    required String userId,
    int? skip,
    int? limit,
  }) async {
    try {
      final Response<Result<Map<String, dynamic>>> response =
          await ProfileService.getBookmarks(
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
}

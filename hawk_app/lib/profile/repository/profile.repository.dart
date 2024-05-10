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

  Future<Result<Map<String, dynamic>>> updateProfile({
    required String id,
    required String firstName,
    required String lastName,
    required String bio,
    XFile? image,
  }) async {

    final MultipartFile? imageFile = image != null ? http.MultipartFile(
        'image',
        File(image.path).readAsBytes().asStream(),
        File(image.path).lengthSync(),
        filename: image.path.split('/').last,
        contentType: MediaType.parse(
          lookupMimeType(image.path) ?? '',
        ),
      ) :
      null
      ;

    try {
      final Response<Result<Map<String, dynamic>>> response = await ProfileService.updateProfile(
        id: id,
        firstName: firstName,
        lastName: lastName,
        bio: bio,
        image: imageFile,
      );
      return response.body as Result<Map<String, dynamic>>;
    } catch (e){
      return Error({"message": "Unexpected Error"});
    }
    
  }

  Future<Result<Map<String, dynamic>>> bookmark({
    required String userId,
    required String productId,
  }) async {
    try{
      final Response<Result<Map<String, dynamic>>> response = await ProfileService.bookmark(
        userId: userId,
        productId: productId,
        body: {}
      );
      return response.body as Result<Map<String, dynamic>>;
    } catch (e){
      return Error({"message": "Unexpected Error"});
    }
  }

  Future<Result<Map<String, dynamic>>> getBookmarks({
    required String userId,
    int? page,
    int? limit,
  }) async {
    try{
      final Response<Result<Map<String, dynamic>>> response = await ProfileService.getBookmarks(
        userId: userId,
        page: page,
        limit: limit,
      );
      return response.body as Result<Map<String, dynamic>>;
    } catch (e){
      return Error({"message": "Unexpected Error"});
    }
  }
}
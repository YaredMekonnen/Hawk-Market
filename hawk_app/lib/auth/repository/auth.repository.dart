import 'dart:io';

import 'package:chopper/chopper.dart';
import 'package:hawk_app/auth/service/auth_service.dart';
import 'package:hawk_app/commons/utils/response.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart' show MultipartFile;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

class AuthRepository {
  final AuthChopperService authService;
  String theme = 'light';
  final storage = new FlutterSecureStorage();
  AuthRepository(this.authService);

  Future<Result<Map<String, dynamic>>> loginUser(
      Map<dynamic, String> data) async {
    try {
      Response<Result<Map<String, dynamic>>> response =
          await authService.loginUser(data);
      if (response.isSuccessful) {
        return response.body as Result<Map<String, dynamic>>;
      } else {
        return Error(response.error as Map<String, dynamic>);
      }
    } catch (e) {
      return Error({"message": "Unexpected Error"});
    }
  }

  Future<Result<Map<String, dynamic>>> getUser() async {
    try {
      Response<Result<Map<String, dynamic>>> response =
          await authService.getUser();
      if (response.isSuccessful) {
        return response.body as Result<Map<String, dynamic>>;
      } else {
        return Error(response.error as Map<String, dynamic>);
      }
    } catch (e) {
      return Error({"message": "Unexpected Error"});
    }
  }

  Future<Result<Map<String, dynamic>>> registerUser({
    required String email,
    required String password,
    required String username,
    XFile? image,
  }) async {
    try {
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
      Response<Result<Map<String, dynamic>>> response =
          await authService.registerUser(
              email: email,
              password: password,
              username: username,
              image: imageFile);

      if (response.isSuccessful) {
        return response.body as Result<Map<String, dynamic>>;
      } else {
        return Error(response.error as Map<String, dynamic>);
      }
    } catch (e) {
      return Error({"message": "Unexpected Error"});
    }
  }

  Future<Result<Map<String, dynamic>>> forgotPassword(
      Map<String, dynamic> data) async {
    try {
      Response<Result<Map<String, dynamic>>> response =
          await authService.forgotPassword(data);
      if (response.isSuccessful) {
        return response.body as Result<Map<String, dynamic>>;
      } else {
        return Error(response.error as Map<String, dynamic>);
      }
    } catch (e) {
      return Error({"message": "Unexpected Error"});
    }
  }

  Future<Result<Map<String, dynamic>>> verifyOtp(
      Map<String, dynamic> data) async {
    try {
      Response<Result<Map<String, dynamic>>> response =
          await authService.verifyOtp(data);
      if (response.isSuccessful) {
        return response.body as Result<Map<String, dynamic>>;
      } else {
        return Error(response.error as Map<String, dynamic>);
      }
    } catch (e) {
      return Error({"message": "Unexpected Error"});
    }
  }

  Future<Result<Map<String, dynamic>>> resetPassword(
      Map<String, dynamic> data) async {
    try {
      Response<Result<Map<String, dynamic>>> response =
          await authService.resetPassword(data);
      if (response.isSuccessful) {
        return response.body as Result<Map<String, dynamic>>;
      } else {
        return Error(response.error as Map<String, dynamic>);
      }
    } catch (e) {
      return Error({"message": "Unexpected Error"});
    }
  }

  Future<String?> checkAuthentication() async {
    String? token = await storage.read(key: 'token');
    if (token == null) {
      return null;
    } else {
      return token;
    }
  }

  setToken(String token) async {
    await storage.write(key: 'token', value: token);
  }

  removeToken() async {
    await storage.delete(key: 'token');
  }
}

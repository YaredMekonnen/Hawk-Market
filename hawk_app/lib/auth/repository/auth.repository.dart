import 'package:chopper/chopper.dart';
import 'package:hawk_app/auth/service/auth_service.dart';
import 'package:hawk_app/commons/utils/response.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthRepository {
  final AuthChopperService authService;
  final storage = new FlutterSecureStorage();
  AuthRepository(this.authService);

  Future<Result<Map<String, dynamic>>> loginUser(Map<dynamic, String> data) async {
    try {
      Response<Result<Map<String, dynamic>>> response = await authService.loginUser(data);
      if (response.isSuccessful){
        return response.body as Result<Map<String, dynamic>>;
      } else {
        return Error(response.error as Map<String, dynamic>);
      }
    } catch (e) {
      return Error({"message": "Unexpected Error"});
    }
  }

  Future<Result<Map<String, dynamic>>> registerUser(Map<String, dynamic> data) async {
    try {
      Response<Result<Map<String, dynamic>>> response = await authService.registerUser(data);
      if (response.isSuccessful){
        return response.body as Result<Map<String, dynamic>>;
      } else {
        return Error(response.error as Map<String, dynamic>);
      }
    } catch (e) {
      return Error({"message": "Unexpected Error"});
    }
  }

  Future<Result<Map<String, dynamic>>> forgotPassword(Map<String, dynamic> data) async {
    try {
      Response<Result<Map<String, dynamic>>> response = await authService.forgotPassword(data);
      if (response.isSuccessful){
        return response.body as Result<Map<String, dynamic>>;
      } else {
        return Error(response.error as Map<String, dynamic>);
      }
    } catch (e) {
      return Error({"message": "Unexpected Error"});
    }
  }

  Future<Result<Map<String, dynamic>>> verifyOtp(Map<String, dynamic> data) async {
    try{
      Response<Result<Map<String, dynamic>>> response = await authService.verifyOtp(data);
      if (response.isSuccessful){
        return response.body as Result<Map<String, dynamic>>;
      } else {
        return Error(response.error as Map<String, dynamic>);
      }
    } catch (e) {
      return Error({"message": "Unexpected Error"});
    }
  }

  Future<Result<Map<String, dynamic>>> resetPassword(Map<String, dynamic> data) async {
    try{
      Response<Result<Map<String, dynamic>>> response = await authService.resetPassword(data);
      if (response.isSuccessful){
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
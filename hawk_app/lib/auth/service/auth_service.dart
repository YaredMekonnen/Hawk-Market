import 'package:chopper/chopper.dart';
import 'package:hawk_app/commons/constants/api_endpoints.dart';
import 'package:hawk_app/commons/utils/response.dart';
import 'package:http/http.dart' show MultipartFile;

part 'auth_service.chopper.dart';

@ChopperApi()
abstract class AuthChopperService extends ChopperService {
  static AuthChopperService create({ChopperClient? client}) =>
      _$AuthChopperService(client);

  @Post(path: APIEndpoints.loginUrl)
  Future<Response<Result<Map<String, dynamic>>>> loginUser(
      @body Map<dynamic, String> data);

  @Get(path: APIEndpoints.user)
  Future<Response<Result<Map<String, dynamic>>>> getUser();

  @Post(
    path: APIEndpoints.registerUrl,
    headers: {
      'Accept': 'application/json',
      'Content-Type': 'multipart/form-data', // <-- important
    },
  )
  @Multipart()
  Future<Response<Result<Map<String, dynamic>>>> registerUser(
      {@Part('email') required String email,
      @Part('password') required String password,
      @Part('username') required String username,
      @PartFile('image') MultipartFile? image});

  @Post(path: APIEndpoints.forgotPasswordUrl)
  Future<Response<Result<Map<String, dynamic>>>> forgotPassword(
      @body Map<String, dynamic> data);

  @Post(path: APIEndpoints.verifyOtpUrl)
  Future<Response<Result<Map<String, dynamic>>>> verifyOtp(
      @body Map<String, dynamic> data);

  @Post(path: APIEndpoints.resetPasswordUrl)
  Future<Response<Result<Map<String, dynamic>>>> resetPassword(
      @body Map<String, dynamic> data);
}

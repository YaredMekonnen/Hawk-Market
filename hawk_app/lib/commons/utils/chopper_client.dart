import 'package:chopper/chopper.dart';
import 'package:hawk_app/auth/blocs/auth_cubit/auth_cubit.dart';
import 'package:hawk_app/auth/repository/auth.repository.dart';
import 'package:hawk_app/auth/service/auth_service.dart';
import 'package:hawk_app/commons/utils/json_converter.dart';
import 'package:hawk_app/create_product/service/product.service.dart';
import 'package:hawk_app/profile/service/profile.service.dart';

class AppChopperClient {
  late ChopperClient _client;
  AppChopperClient() {
    createChopperClient();
  }

  late AuthCubit authCubit; // will be initialized in main.dart when AuhCubit is created

  T getChopperService<T extends ChopperService>() {
    return _client.getService<T>();
  }

  Request applyHeaderInterceptor(Request req) {
    final headers = req.headers;
    headers['Authorization'] = 'Bearer ${authCubit.token}';
    return req.copyWith(headers: headers);
  }

  Response responseInterceptor(Response res) {
    if (res.statusCode == 401) {
      authCubit.logout();
    }
    return res;
  }

  void createChopperClient() {
    _client = ChopperClient(
        baseUrl: Uri.parse("http://10.0.2.2:3000/"),
        services: [
          AuthChopperService.create(),
          ProductChooperService.create(),
          ProfileChooperService.create(),
        ],
        interceptors: [
          applyHeaderInterceptor,
          responseInterceptor,
        ],
        converter: JsonToMapConverter(),
        errorConverter: const JsonConverter(),
      );
  }
}
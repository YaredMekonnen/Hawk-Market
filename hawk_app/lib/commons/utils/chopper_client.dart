import 'package:chopper/chopper.dart';
import 'package:hawk_app/auth/blocs/auth_cubit/auth_cubit.dart';
import 'package:hawk_app/auth/service/auth_service.dart';
import 'package:hawk_app/chat/service/chat_service.dart';
import 'package:hawk_app/commons/constants/api_endpoints.dart';
import 'package:hawk_app/commons/utils/json_converter.dart';
import 'package:hawk_app/create_product/service/product.service.dart';
import 'package:hawk_app/home/service/story.service.dart';
import 'package:hawk_app/payment/service/payment_service.dart';
import 'package:hawk_app/profile/service/profile.service.dart';

class AppChopperClient {
  late ChopperClient _client;
  AppChopperClient() {
    createChopperClient();
  }

  late AuthCubit
      authCubit; // will be initialized in main.dart when AuhCubit is created

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
      baseUrl: Uri.parse(APIEndpoints.baseUrl),
      services: [
        AuthChopperService.create(),
        ProductChooperService.create(),
        ProfileChooperService.create(),
        ChatChopperService.create(),
        StoryChooperService.create(),
        PaymentChopperService.create(),
      ],
      interceptors: [
        applyHeaderInterceptor,
        responseInterceptor,
      ],
      converter: JsonToMapConverter(),
    );
  }
}

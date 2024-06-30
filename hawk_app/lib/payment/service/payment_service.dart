import 'package:chopper/chopper.dart';
import 'package:hawk_app/commons/constants/api_endpoints.dart';
import 'package:hawk_app/commons/utils/response.dart';

part 'payment_service.chopper.dart';

@ChopperApi()
abstract class PaymentChopperService extends ChopperService {
  static PaymentChopperService create({ChopperClient? client}) =>
      _$PaymentChopperService(client);

  @Post(path: '${APIEndpoints.payment}/create')
  Future<Response<Result<Map<String, dynamic>>>> createPaymentIntent(
      @body Map<String, dynamic> data);

  @Post(path: '${APIEndpoints.payment}/confirm')
  Future<Response<Result<Map<String, dynamic>>>> confirmPaymentIntent(
      @body Map<String, dynamic> data);
}

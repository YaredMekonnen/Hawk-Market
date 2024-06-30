import 'package:chopper/chopper.dart';
import 'package:hawk_app/commons/utils/response.dart';
import 'package:hawk_app/payment/service/payment_service.dart';

class PaymentRepository {
  PaymentRepository(this.paymentService);

  final PaymentChopperService paymentService;

  Future<Result<Map<String, dynamic>>> createPaymentIntent({
    required Map<String, dynamic> data,
  }) async {
    try {
      final Response<Result<Map<String, dynamic>>> response =
          await paymentService.createPaymentIntent(data);

      if (response.isSuccessful) {
        return response.body as Result<Map<String, dynamic>>;
      } else {
        return Error(response.error as Map<String, dynamic>);
      }
    } catch (e) {
      return Error({"message": "Unexpected Error"});
    }
  }

  Future<Result<Map<String, dynamic>>> confirmPaymentIntent({
    required Map<String, dynamic> data,
  }) async {
    try {
      final Response<Result<Map<String, dynamic>>> response =
          await paymentService.confirmPaymentIntent(data);

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

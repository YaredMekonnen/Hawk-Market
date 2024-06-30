// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$PaymentChopperService extends PaymentChopperService {
  _$PaymentChopperService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = PaymentChopperService;

  @override
  Future<Response<Result<Map<String, dynamic>>>> createPaymentIntent(
      Map<String, dynamic> data) {
    final Uri $url = Uri.parse('/payment/create');
    final $body = data;
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
  Future<Response<Result<Map<String, dynamic>>>> confirmPaymentIntent(
      Map<String, dynamic> data) {
    final Uri $url = Uri.parse('/payment/confirm');
    final $body = data;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client
        .send<Result<Map<String, dynamic>>, Map<String, dynamic>>($request);
  }
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$ProductChooperService extends ProductChooperService {
  _$ProductChooperService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = ProductChooperService;

  @override
  Future<Response<Result<Map<String, dynamic>>>> createProduct({
    required String tags,
    required String name,
    required String description,
    required num price,
    required List<MultipartFile> images,
  }) {
    final Uri $url = Uri.parse('/product');
    final Map<String, String> $headers = {
      'Accept': 'application/json',
      'Content-Type': 'multipart/form-data',
    };
    final List<PartValue> $parts = <PartValue>[
      PartValue<String>(
        'tags',
        tags,
      ),
      PartValue<String>(
        'name',
        name,
      ),
      PartValue<String>(
        'description',
        description,
      ),
      PartValue<num>(
        'price',
        price,
      ),
      PartValueFile<List<MultipartFile>>(
        'images',
        images,
      ),
    ];
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parts: $parts,
      multipart: true,
      headers: $headers,
    );
    return client
        .send<Result<Map<String, dynamic>>, Map<String, dynamic>>($request);
  }

  @override
  Future<Response<Result<Map<String, dynamic>>>> getProducts({
    int? page,
    int? limit,
    String? search,
  }) {
    final Uri $url = Uri.parse('/product');
    final Map<String, dynamic> $params = <String, dynamic>{
      'page': page,
      'limit': limit,
      'search': search,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client
        .send<Result<Map<String, dynamic>>, Map<String, dynamic>>($request);
  }

  @override
  Future<Response<Result<Map<String, dynamic>>>> getPostedProducts({
    required String userId,
    int? page,
    int? limit,
  }) {
    final Uri $url = Uri.parse('/productposted/${userId}');
    final Map<String, dynamic> $params = <String, dynamic>{
      'page': page,
      'limit': limit,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client
        .send<Result<Map<String, dynamic>>, Map<String, dynamic>>($request);
  }

  @override
  Future<Response<Result<Map<String, dynamic>>>> getProduct(String id) {
    final Uri $url = Uri.parse('/product');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client
        .send<Result<Map<String, dynamic>>, Map<String, dynamic>>($request);
  }

  @override
  Future<Response<Result<Map<String, dynamic>>>> deleteProduct(String id) {
    final Uri $url = Uri.parse('/product');
    final Request $request = Request(
      'DELETE',
      $url,
      client.baseUrl,
    );
    return client
        .send<Result<Map<String, dynamic>>, Map<String, dynamic>>($request);
  }
}

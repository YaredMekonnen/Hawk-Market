import 'dart:io';

import 'package:chopper/chopper.dart';
import 'package:hawk_app/commons/utils/response.dart';
import 'package:hawk_app/create_product/models/product.dart';
import 'package:hawk_app/create_product/service/product.service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart' show MultipartFile;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

class ProductRepository {

  ProductRepository(this.productService);

  final ProductChooperService productService;

  Future<Result<Map<String, dynamic>>> createProduct({
    required String tags,
    required String name,
    required String description,
    required num price,
    required List<XFile> images,
  }) async {

    final List<MultipartFile> imageFiles = images.map((image) {
      return http.MultipartFile(
        'images',
        File(image.path).readAsBytes().asStream(),
        File(image.path).lengthSync(),
        filename: image.path.split('/').last,
        contentType: MediaType.parse(
          lookupMimeType(image.path) ?? '',
        ),
      );
    }).toList();

    try {
      final Response<Result<Map<String, dynamic>>> response = await productService.createProduct(
        tags: tags,
        name: name,
        description: description,
        price: price,
        images: imageFiles,
      );
      return response.body as Result<Map<String, dynamic>>;
    } catch (e){
      return Error({"message": "Unexpected Error"});
    }
    
  }

  Future<Result<Map<String, dynamic>>> getProducts({
    required int page,
    required int limit,

  }) async {
    try{
      final Response<Result<Map<String, dynamic>>> response = await productService.getProducts(
        page: page,
        limit: limit,
        search: '',
      );
      return response.body as Result<Map<String, dynamic>>;
    } catch (e){
      return Error({"message": "Unexpected Error"});
    }
  }

  Future<Result<Map<String, dynamic>>> getPostedProducts({
    required String userId,
    required int page,
    required int limit,

  }) async {
    try{
      final Response<Result<Map<String, dynamic>>> response = await productService.getPostedProducts(
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
import 'package:chopper/chopper.dart';
import 'package:hawk_app/commons/utils/response.dart';
import 'package:http/http.dart' show MultipartFile;
import 'package:hawk_app/commons/constants/api_endpoints.dart';

part 'product.service.chopper.dart';

@ChopperApi()
abstract class ProductChooperService extends ChopperService {
  static ProductChooperService create({ChopperClient? client}) =>
      _$ProductChooperService(client);

  @Post(
    path: APIEndpoints.product,
    headers: {
      'Accept': 'application/json',
      'Content-Type': 'multipart/form-data', // <-- important
    },
  )
  @Multipart()
  Future<Response<Result<Map<String, dynamic>>>> createProduct({
    @Part('tags') required String tags,
    @Part('name') required String name,
    @Part('description') required String description,
    @Part('price') required num price,
    @PartFile('images') required List<MultipartFile> images,
  });

  @Get(
    path: APIEndpoints.product,
  )
  Future<Response<Result<Map<String, dynamic>>>> getProducts({
    @Query('skip') int? skip,
    @Query('limit') int? limit,
    @Query('search') String? search,
  });

  @Get(
    path: APIEndpoints.product + '/posted/{userId}',
  )
  Future<Response<Result<Map<String, dynamic>>>> getPostedProducts({
    @Path('userId') required String userId,
    @Query('skip') int? skip,
    @Query('limit') int? limit,
  });

  @Get(
    path: '${APIEndpoints.product}/{id}',
  )
  Future<Response<Result<Map<String, dynamic>>>> getProduct(
    @Path('id') String id,
  );

  @Delete(
    path: APIEndpoints.product + '/{id}',
  )
  Future<Response<Result<Map<String, dynamic>>>> deleteProduct(
    @Path('id') String id,
  );
}

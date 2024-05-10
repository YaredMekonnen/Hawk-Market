import 'package:chopper/chopper.dart';
import 'package:hawk_app/commons/utils/response.dart';
import 'package:http/http.dart' show MultipartFile;
import 'package:hawk_app/commons/constants/api_endpoints.dart';

part 'profile.service.chopper.dart';

@ChopperApi()
abstract class ProfileChooperService extends ChopperService {

  static ProfileChooperService create({ChopperClient? client}) => _$ProfileChooperService(client);

  @Post(
    path: APIEndpoints.profile + 'bookmark/{productId}/{userId}',
  )
  Future<Response<Result<Map<String, dynamic>>>> bookmark({
    @Path('productId') required String productId,
    @Path('userId') required String userId,
    @Body() required Map<String, dynamic> body,
  });

  @Put(
    path: APIEndpoints.profile + '/{id}',
    headers: {
      'Accept': 'application/json',
      'Content-Type': 'multipart/form-data', // <-- important
    },
  )
  @Multipart()
  Future<Response<Result<Map<String, dynamic>>>> updateProfile(
    {
      @Path('id') required String id,
      @Part('firstName') required String firstName,
      @Part('lastName') required String lastName,
      @Part('bio') required String bio,
      @PartFile('image') required MultipartFile? image,
    }
  );

  @Get(
    path: APIEndpoints.profile + '/bookmark/{userId}',
  )
  Future<Response<Result<Map<String, dynamic>>>> getBookmarks(
    {
      @Path('userId') required String userId,
      @Query('page') int? page,
      @Query('limit') int? limit,
    }
  );

  @Get(
    path: APIEndpoints.profile,
  )
  Future<Response<Result<Map<String, dynamic>>>> getProfile(
    @Path('id') String id,
  );

  @Delete(
    path: APIEndpoints.profile,
  )
  Future<Response<Result<Map<String, dynamic>>>> deleteProfile(
    @Path('id') String id,
  );
  
}
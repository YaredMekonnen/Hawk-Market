import 'dart:convert';

import 'package:chopper/chopper.dart';
import 'package:hawk_app/commons/utils/response.dart';

class JsonToMapConverter implements Converter {
  JsonToMapConverter();

  @override
  Request convertRequest(Request request) {
    final req = applyHeader(
      request,
      contentTypeKey,
      jsonHeaders,
      override: false,
    );

    return encodeJson(req);
  }

  @override
  Response<BodyType> convertResponse<BodyType, InnerType>(Response response) {
    return decodeJson(response);
  }

  Request encodeJson(Request request) {
    return request.copyWith(
      body: json.encode(request.body),
    );
  }

  Response<BodyType> decodeJson<BodyType, InnerType>(Response response) {
    try {
      var body = utf8.decode(response.bodyBytes);
      final Map<String, dynamic> mapData = json.decode(body);
      return response.copyWith<BodyType>(body: Success(mapData) as BodyType);
    } catch (e) {
      return response.copyWith<BodyType>(
          body: Error({"message": "Unexpected Error"}) as BodyType);
    }
  }
}

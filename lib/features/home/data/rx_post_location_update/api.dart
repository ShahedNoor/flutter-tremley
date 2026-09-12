import 'dart:convert';

import 'package:dio/dio.dart';

import '../../../../networks/dio/dio.dart';
import '../../../../networks/endpoints.dart';
import '../../../../networks/exception_handler/data_source.dart';

final class PostLocationUpdateApi {
  static final PostLocationUpdateApi _singleton =
      PostLocationUpdateApi._internal();
  PostLocationUpdateApi._internal();
  static PostLocationUpdateApi get instance => _singleton;

  Future<Map> postLocationUpdate({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final FormData formData = FormData.fromMap({
        "latitude": latitude,
        "longitude": longitude,
      });

      final Response response = await postHttp(
        Endpoints.updateLocation(),
        formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(json.encode(response.data));
      } else {
        throw DataSource.DEFAULT.getFailure();
      }
    } catch (error) {
      rethrow;
    }
  }
}

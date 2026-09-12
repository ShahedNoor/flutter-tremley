import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../networks/dio/dio.dart';
import '../../../../networks/endpoints.dart';
import '../../../../networks/exception_handler/data_source.dart';

final class GetSalonReviewsApi {
  static final GetSalonReviewsApi _singleton = GetSalonReviewsApi._internal();
  GetSalonReviewsApi._internal();
  static GetSalonReviewsApi get instance => _singleton;

  Future<Map> getSalonReviews(int id, int perPage) async {
    try {
      Response response = await getHttp(Endpoints.salonReviews(id, perPage));
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

import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../networks/dio/dio.dart';
import '../../../../networks/endpoints.dart';
import '../../../../networks/exception_handler/data_source.dart';

final class GetRecentSalonOrBarberApi {
  static final GetRecentSalonOrBarberApi _singleton = GetRecentSalonOrBarberApi._internal();
  GetRecentSalonOrBarberApi._internal();
  static GetRecentSalonOrBarberApi get instance => _singleton;

  Future<Map> getRecentSalonOrBarberData({
    required double latitude,
    required double longitude,
    required String type,
    int perPage = 15,
  }) async {
    try {
      final Map<String, dynamic> body = {
        "latitude": latitude,
        "longitude": longitude,
        "type": type,
        "per_page": perPage,
      };
      
      Response response = await postHttp(Endpoints.salonOrBarberRecent(), body);
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

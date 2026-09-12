import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../networks/dio/dio.dart';
import '../../../../networks/endpoints.dart';
import '../../../../networks/exception_handler/data_source.dart';

final class GetSalonOrBarberApi {
  static final GetSalonOrBarberApi _singleton = GetSalonOrBarberApi._internal();
  GetSalonOrBarberApi._internal();
  static GetSalonOrBarberApi get instance => _singleton;

  Future<Map> getSalonOrBarberData({
    required double latitude,
    required double longitude,
    required String type,
    String? search,
    double? radius,
  }) async {
    try {
      final Map<String, dynamic> body = {
        "latitude": latitude,
        "longitude": longitude,
        "type": type,
      };
      if (search != null && search.isNotEmpty) {
        body["search"] = search;
      }
      if (radius != null) {
        body["radius"] = radius;
      }
      Response response = await postHttp(Endpoints.salonOrBarber(), body);
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

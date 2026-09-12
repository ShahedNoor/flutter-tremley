import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../networks/dio/dio.dart';
import '../../../../networks/endpoints.dart';
import '../../../../networks/exception_handler/data_source.dart';

final class GetBarberListApi {
  static final GetBarberListApi _singleton = GetBarberListApi._internal();
  GetBarberListApi._internal();
  static GetBarberListApi get instance => _singleton;

  Future<Map> getBarberListData(int salonId) async {
    try {
      final Response response = await getHttp(Endpoints.barberList(salonId));
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

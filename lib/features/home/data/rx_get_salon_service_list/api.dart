import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../networks/dio/dio.dart';
import '../../../../networks/endpoints.dart';
import '../../../../networks/exception_handler/data_source.dart';

final class GetSalonServiceListApi {
  static final GetSalonServiceListApi _singleton =
      GetSalonServiceListApi._internal();
  GetSalonServiceListApi._internal();
  static GetSalonServiceListApi get instance => _singleton;

  Future<Map> getSalonServiceListData(int salonId) async {
    try {
      final Response response =
          await getHttp(Endpoints.salonServiceList(salonId));
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

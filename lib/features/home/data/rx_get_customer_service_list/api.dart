import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../networks/dio/dio.dart';
import '../../../../networks/endpoints.dart';
import '../../../../networks/exception_handler/data_source.dart';

final class GetCustomerServiceListApi {
  static final GetCustomerServiceListApi _singleton =
      GetCustomerServiceListApi._internal();
  GetCustomerServiceListApi._internal();
  static GetCustomerServiceListApi get instance => _singleton;

  Future<Map> getCustomerServiceListData() async {
    try {
      final Response response =
          await getHttp(Endpoints.getCustomerBarberServiceList());
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

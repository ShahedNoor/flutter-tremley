import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../networks/dio/dio.dart';
import '../../../../networks/endpoints.dart';
import '../../../../networks/exception_handler/data_source.dart';

final class GetBookingDetailsApi {
  static final GetBookingDetailsApi _singleton = GetBookingDetailsApi._internal();
  GetBookingDetailsApi._internal();
  static GetBookingDetailsApi get instance => _singleton;

  Future<Map<String, dynamic>> getBookingDetails(int id) async {
    try {
      Response response = await getHttp(Endpoints.bookingDetails(id));
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

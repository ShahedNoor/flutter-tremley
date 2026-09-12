import 'package:dio/dio.dart';
import '../../../../networks/dio/dio.dart';
import '../../../../networks/endpoints.dart';
import '../../../../networks/exception_handler/data_source.dart';

final class PostAsapBookingApi {
  static final PostAsapBookingApi _singleton = PostAsapBookingApi._internal();
  PostAsapBookingApi._internal();
  static PostAsapBookingApi get instance => _singleton;

  Future<Map<String, dynamic>> postBooking({
    required Map<String, dynamic> data,
  }) async {
    try {
      Response response = await postHttp(Endpoints.asSoonAsPossible(), data);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      } else {
        throw DataSource.DEFAULT.getFailure();
      }
    } catch (error) {
      rethrow;
    }
  }
}

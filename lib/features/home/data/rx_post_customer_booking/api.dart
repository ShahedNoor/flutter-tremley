import 'dart:developer';
import '../../../../networks/dio/dio.dart';
import '../../../../networks/endpoints.dart';

final class PostCustomerBookingApi {
  static final PostCustomerBookingApi _singleton = PostCustomerBookingApi._internal();
  PostCustomerBookingApi._internal();
  static PostCustomerBookingApi get instance => _singleton;

  Future<Map<String, dynamic>> postBooking({
    required Map<String, dynamic> data,
  }) async {
    try {
      final response = await DioSingleton.instance.dio.post(
        Endpoints.customerBooking(),
        data: data,
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        log('Error booking: ${response.data}');
        throw Exception("Failed to book slot");
      }
    } catch (e) {
      log('Error booking: $e');
      rethrow;
    }
  }
}

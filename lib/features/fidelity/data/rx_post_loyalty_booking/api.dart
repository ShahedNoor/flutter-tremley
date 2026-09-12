import 'dart:developer';
import '../../../../networks/dio/dio.dart';
import '../../../../networks/endpoints.dart';

final class PostLoyaltyBookingApi {
  static final PostLoyaltyBookingApi _singleton = PostLoyaltyBookingApi._internal();
  PostLoyaltyBookingApi._internal();
  static PostLoyaltyBookingApi get instance => _singleton;

  Future<Map<String, dynamic>> postLoyaltyBooking({
    required Map<String, dynamic> data,
  }) async {
    try {
      final response = await DioSingleton.instance.dio.post(
        Endpoints.loyaltyBooking(),
        data: data,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      } else {
        log('Error booking: ${response.data}');
        throw Exception("Failed to book loyalty slot");
      }
    } catch (e) {
      log('Error loyalty booking: $e');
      rethrow;
    }
  }
}

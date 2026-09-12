import 'dart:developer';
import '../../../../networks/dio/dio.dart';
import '../../../../networks/endpoints.dart';

final class CancelReservationApi {
  static final CancelReservationApi _singleton = CancelReservationApi._internal();
  CancelReservationApi._internal();
  static CancelReservationApi get instance => _singleton;

  Future<Map<String, dynamic>> cancel(int id) async {
    try {
      final response = await DioSingleton.instance.dio.get(
        Endpoints.cancelReservation(id),
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        log('Error cancelling: ${response.data}');
        throw Exception("Failed to cancel reservation");
      }
    } catch (e) {
      log('Error cancelling: $e');
      rethrow;
    }
  }
}

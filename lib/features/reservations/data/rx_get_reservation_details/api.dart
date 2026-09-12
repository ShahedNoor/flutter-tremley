import '../../../../networks/dio/dio.dart';
import '../../../../networks/endpoints.dart';

final class GetReservationDetailsApi {
  static final GetReservationDetailsApi _singleton = GetReservationDetailsApi._internal();
  GetReservationDetailsApi._internal();
  static GetReservationDetailsApi get instance => _singleton;

  Future<Map<String, dynamic>> getReservationDetails(int id) async {
    try {
      final response = await DioSingleton.instance.dio.get(
        Endpoints.reservationDetails(id),
      );
      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception("Failed to fetch reservation details");
      }
    } catch (error) {
      rethrow;
    }
  }
}

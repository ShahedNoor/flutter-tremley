import '../../../../networks/dio/dio.dart';
import '../../../../networks/endpoints.dart';

final class GetReservationsApi {
  static final GetReservationsApi _singleton = GetReservationsApi._internal();
  GetReservationsApi._internal();
  static GetReservationsApi get instance => _singleton;

  Future<Map<String, dynamic>> getReservations(String type) async {
    try {
      final response = await DioSingleton.instance.dio.get(
        Endpoints.reservations(type),
      );
      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception("Failed to fetch reservations");
      }
    } catch (error) {
      rethrow;
    }
  }
}

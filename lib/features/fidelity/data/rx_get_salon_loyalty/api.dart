import '../../../../networks/dio/dio.dart';
import '../../../../networks/endpoints.dart';

class GetSalonLoyaltyApi {
  static final GetSalonLoyaltyApi _singleton = GetSalonLoyaltyApi._internal();
  GetSalonLoyaltyApi._internal();
  static GetSalonLoyaltyApi get instance => _singleton;

  Future<Map<String, dynamic>> fetchSalonLoyalty(String salonId) async {
    try {
      final response = await DioSingleton.instance.dio.get(
        Endpoints.salonLoyalty(salonId),
      );
      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception("Failed to load salon loyalty");
      }
    } catch (e) {
      rethrow;
    }
  }
}

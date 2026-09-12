import '../../../../networks/dio/dio.dart';
import '../../../../networks/endpoints.dart';

class GetLoyaltyHistoryApi {
  static final GetLoyaltyHistoryApi _singleton = GetLoyaltyHistoryApi._internal();
  GetLoyaltyHistoryApi._internal();
  static GetLoyaltyHistoryApi get instance => _singleton;

  Future<Map<String, dynamic>> fetchLoyaltyHistory() async {
    try {
      final response = await DioSingleton.instance.dio.get(
        Endpoints.loyaltyHistory(),
      );
      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception("Failed to load loyalty history");
      }
    } catch (e) {
      rethrow;
    }
  }
}

import '../../../../networks/dio/dio.dart';
import '../../../../networks/endpoints.dart';

final class GetPaymentStatusApi {
  static final GetPaymentStatusApi _singleton = GetPaymentStatusApi._internal();
  GetPaymentStatusApi._internal();
  static GetPaymentStatusApi get instance => _singleton;

  Future<Map<String, dynamic>> getPaymentStatus(int id) async {
    try {
      final response = await DioSingleton.instance.dio.get(
        Endpoints.paymentStatus(id),
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception("Failed to get payment status");
      }
    } catch (error) {
      rethrow;
    }
  }
}

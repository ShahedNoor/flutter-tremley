import 'package:dio/dio.dart';
import '../../../../networks/dio/dio.dart';
import '../../../../networks/endpoints.dart';
import '../../../../networks/exception_handler/data_source.dart';

final class GetReadNotificationApi {
  static final GetReadNotificationApi _singleton = GetReadNotificationApi._internal();
  GetReadNotificationApi._internal();
  static GetReadNotificationApi get instance => _singleton;

  Future<Map> getReadNotificationData(String id) async {
    try {
      Response response = await getHttp(Endpoints.readNotification(id));
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

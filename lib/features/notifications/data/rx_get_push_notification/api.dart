import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../networks/dio/dio.dart';
import '../../../../networks/endpoints.dart';
import '../../../../networks/exception_handler/data_source.dart';

final class GetPushNotificationApi {
  static final GetPushNotificationApi _singleton = GetPushNotificationApi._internal();
  GetPushNotificationApi._internal();
  static GetPushNotificationApi get instance => _singleton;

  Future<Map> getPushNotificationData() async {
    try {
      Response response = await getHttp(Endpoints.getPushNotification());
      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(json.encode(response.data));
      } else {
        throw DataSource.DEFAULT.getFailure();
      }
    } catch (error) {
      rethrow;
    }
  }
}

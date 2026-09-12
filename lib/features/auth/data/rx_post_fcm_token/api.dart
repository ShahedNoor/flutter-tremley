import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../networks/dio/dio.dart';
import '../../../../networks/endpoints.dart';
import '../../../../networks/exception_handler/data_source.dart';

final class PostFcmTokenApi {
  static final PostFcmTokenApi _singleton = PostFcmTokenApi._internal();
  PostFcmTokenApi._internal();
  static PostFcmTokenApi get instance => _singleton;

  Future<Map> postFcmToken({
    required String fcmToken,
    required String deviceId,
  }) async {
    try {
      Map<String, dynamic> data = {
        "fcm_token": fcmToken,
        "device_id": deviceId,
      };

      Response response = await postHttp(Endpoints.fcmToken(), data);
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

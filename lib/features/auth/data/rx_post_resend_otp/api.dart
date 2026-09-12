import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../networks/dio/dio.dart';
import '../../../../networks/endpoints.dart';
import '../../../../networks/exception_handler/data_source.dart';

final class PostResendOtpApi {
  static final PostResendOtpApi _singleton = PostResendOtpApi._internal();
  PostResendOtpApi._internal();
  static PostResendOtpApi get instance => _singleton;

  Future<Map> postResendOtp({required String email}) async {
    try {
      Map<String, dynamic> data = {"email": email};
      Response response = await postHttp(Endpoints.resendOtp(), data);

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

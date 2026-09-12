import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../networks/dio/dio.dart';
import '../../../../networks/endpoints.dart';
import '../../../../networks/exception_handler/data_source.dart';

final class PostVerifyOTPApi {
  static final PostVerifyOTPApi _singleton = PostVerifyOTPApi._internal();
  PostVerifyOTPApi._internal();
  static PostVerifyOTPApi get instance => _singleton;

  Future<Map> postVerifyOTP({required String email, required String otp}) async {
    try {
      Map<String, dynamic> data = {"email": email, "otp": otp};
      Response response = await postHttp(
        Endpoints.verifyOTP(email: email, otp: otp),
        data,
      );
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

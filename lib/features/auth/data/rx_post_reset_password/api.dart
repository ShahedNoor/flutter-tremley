import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../networks/dio/dio.dart';
import '../../../../networks/endpoints.dart';
import '../../../../networks/exception_handler/data_source.dart';

final class PostResetPasswordApi {
  static final PostResetPasswordApi _singleton = PostResetPasswordApi._internal();
  PostResetPasswordApi._internal();
  static PostResetPasswordApi get instance => _singleton;

  Future<Map> postResetPassword({
    required String token,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      Map<String, dynamic> data = {
        "reset_password_token": token,
        "email": email,
        "password": password,
        "password_confirmation": passwordConfirmation,
      };
      Response response = await postHttp(Endpoints.resetPassword(), data);
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

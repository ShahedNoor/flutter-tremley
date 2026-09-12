import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../networks/dio/dio.dart';
import '../../../../networks/endpoints.dart';
import '../../../../networks/exception_handler/data_source.dart';

final class PostChangePasswordApi {
  static final PostChangePasswordApi _singleton = PostChangePasswordApi._internal();
  PostChangePasswordApi._internal();
  static PostChangePasswordApi get instance => _singleton;

  Future<Map> postChangePassword({
    required String currentPassword,
    required String newPassword,
    required String email,
  }) async {
    try {
      Map<String, dynamic> data = {
        "current_password": currentPassword,
        "new_password": newPassword,
        "email": email,
      };
      Response response = await postHttp(Endpoints.changePassword(), data);
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

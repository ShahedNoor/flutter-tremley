import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../networks/dio/dio.dart';
import '../../../../networks/endpoints.dart';
import '../../../../networks/exception_handler/data_source.dart';

final class PostLoginApi {
  static final PostLoginApi _singleton = PostLoginApi._internal();
  PostLoginApi._internal();
  static PostLoginApi get instance => _singleton;

  Future<Map> postLogin({
    required String email,
    required String password,
  }) async {
    try {
      Map<String, dynamic> data = {
        "email": email,
        "password": password,
      };

      Response response = await postHttp(Endpoints.logIn(), data);
      
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

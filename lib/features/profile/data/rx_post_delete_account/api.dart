import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../networks/dio/dio.dart';
import '../../../../networks/endpoints.dart';
import '../../../../networks/exception_handler/data_source.dart';

final class PostDeleteAccountApi {
  static final PostDeleteAccountApi _singleton = PostDeleteAccountApi._internal();
  PostDeleteAccountApi._internal();
  static PostDeleteAccountApi get instance => _singleton;

  Future<Map> postDeleteAccount() async {
    try {
      Response response = await postHttp(Endpoints.deleteAccount());
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

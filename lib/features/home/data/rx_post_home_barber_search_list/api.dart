import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../networks/dio/dio.dart';
import '../../../../networks/endpoints.dart';
import '../../../../networks/exception_handler/data_source.dart';

final class PostHomeBarberSearchListApi {
  static final PostHomeBarberSearchListApi _singleton = PostHomeBarberSearchListApi._internal();
  PostHomeBarberSearchListApi._internal();
  static PostHomeBarberSearchListApi get instance => _singleton;

  Future<Map<String, dynamic>> postSearchList({required Map<String, dynamic> data}) async {
    try {
      Response response = await postHttp(Endpoints.homeBarberSearchList(), data);
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data is Map<String, dynamic>) {
          return response.data;
        } else {
          return json.decode(json.encode(response.data));
        }
      } else {
        throw DataSource.DEFAULT.getFailure();
      }
    } catch (error) {
      rethrow;
    }
  }
}

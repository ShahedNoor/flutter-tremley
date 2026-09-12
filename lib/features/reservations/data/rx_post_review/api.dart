import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../../networks/dio/dio.dart';
import '../../../../../networks/endpoints.dart';

final class PostReviewApi {
  static final PostReviewApi _singleton = PostReviewApi._internal();
  PostReviewApi._internal();
  static PostReviewApi get instance => _singleton;

  Future<Map<String, dynamic>> postReview(Map<String, dynamic> data) async {
    try {
      Response response = await postHttp(
        Endpoints.postReview(),
        data,
      );
      if (response.statusCode == 200) {
        final data = json.decode(json.encode(response.data));
        return data;
      } else {
        throw Exception("Status code: ${response.statusCode}");
      }
    } catch (e) {
      rethrow;
    }
  }
}

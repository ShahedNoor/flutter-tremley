import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../networks/dio/dio.dart';
import '../../../../networks/endpoints.dart';
import '../../../../networks/exception_handler/data_source.dart';

final class PostHelpSupportApi {
  static final PostHelpSupportApi _singleton = PostHelpSupportApi._internal();
  PostHelpSupportApi._internal();
  static PostHelpSupportApi get instance => _singleton;

  Future<Map> postSupport({
    required String subject,
    required String message,
    required String email,
    required String name,
  }) async {
    try {
      final data = {
        "subject": subject,
        "message": message,
        "email": email,
        "name": name,
      };

      Response response = await postHttp(Endpoints.helpSupport(), data);
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

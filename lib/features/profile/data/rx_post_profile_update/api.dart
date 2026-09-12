import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../networks/dio/dio.dart';
import '../../../../networks/endpoints.dart';
import '../../../../networks/exception_handler/data_source.dart';

final class PostProfileUpdateApi {
  static final PostProfileUpdateApi _singleton =
      PostProfileUpdateApi._internal();
  PostProfileUpdateApi._internal();
  static PostProfileUpdateApi get instance => _singleton;

  Future<Map> postProfileUpdate({
    required String name,
    required String email,
    required String phone,
    String? imagePath,
  }) async {
    try {
      FormData formData = FormData.fromMap({
        "name": name,
        "email": email,
        "phone": phone,
        if (imagePath != null)
          "profile_image": await MultipartFile.fromFile(imagePath),
      });

      Response response = await postHttp(Endpoints.updateProfile(), formData);

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

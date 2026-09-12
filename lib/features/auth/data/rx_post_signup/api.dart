import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../networks/dio/dio.dart';
import '../../../../networks/endpoints.dart';
import '../../../../networks/exception_handler/data_source.dart';

final class PostSignupApi {
  static final PostSignupApi _singleton = PostSignupApi._internal();
  PostSignupApi._internal();
  static PostSignupApi get instance => _singleton;

  Future<Map> postSignup({
    required String name,
    required String phone,
    required String email,
    required String password,
    required String passwordConfirmation,
    required String role,
    required String userType,
    required String postalCode,
  }) async {
    try {
      Map<String, dynamic> data = {
        "name": name,
        "phone": phone,
        "email": email,
        "password": password,
        "password_confirmation": passwordConfirmation,
        "role": role,
        "user_type": userType,
        "postal_code": postalCode,
      };

      Response response = await postHttp(Endpoints.signup(), data);
      
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

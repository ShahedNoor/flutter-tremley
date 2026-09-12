import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../networks/dio/dio.dart';
import '../../../../networks/endpoints.dart';
import '../../../../networks/exception_handler/data_source.dart';

final class GetConversationApi {
  static final GetConversationApi _singleton = GetConversationApi._internal();
  GetConversationApi._internal();
  static GetConversationApi get instance => _singleton;

  Future<Map> getConversation(String conversationId) async {
    try {
      Response response = await getHttp(Endpoints.chatGet(conversationId));
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

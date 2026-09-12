import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../networks/dio/dio.dart';
import '../../../../networks/endpoints.dart';
import '../../../../networks/exception_handler/data_source.dart';

final class ChatSendApi {
  static final ChatSendApi _singleton = ChatSendApi._internal();
  ChatSendApi._internal();
  static ChatSendApi get instance => _singleton;

  Future<Map> sendChatMessage({
    required String receiverId,
    required String message,
  }) async {
    try {
      FormData formData = FormData.fromMap({
        "receiver_id": receiverId,
        "message": message,
      });

      Response response = await postHttp(Endpoints.chatSend(), formData);
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

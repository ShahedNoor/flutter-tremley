import 'package:rxdart/rxdart.dart';
import '../../../../helpers/error_message_handler.dart';
import '../../../../networks/rx_base.dart';
import 'api.dart';

final class PostFcmTokenRx extends RxResponseInt<Map> {
  final api = PostFcmTokenApi.instance;

  PostFcmTokenRx({required super.empty, required super.dataFetcher});

  ValueStream<Map> get dataStream => dataFetcher.stream;

  Future<bool> postFcmToken({
    required String fcmToken,
    required String deviceId,
  }) async {
    try {
      Map data = await api.postFcmToken(
        fcmToken: fcmToken,
        deviceId: deviceId,
      );
      return await handleSuccessWithReturn(data);
    } catch (error) {
      return await handleErrorWithReturn(error);
    }
  }

  @override
  handleSuccessWithReturn(data) async {
    dataFetcher.sink.add(data);
    return true;
  }

  @override
  handleErrorWithReturn(error) {
    ErrorMessageHandler.showErrorToast(error);
    return false;
  }
}

import 'package:rxdart/rxdart.dart';
import '../../../../helpers/error_message_handler.dart';
import '../../../../networks/rx_base.dart';
import '../../model/push_notification_model.dart';
import 'api.dart';

final class GetPushNotificationRx extends RxResponseInt<PushNotificationModel> {
  final api = GetPushNotificationApi.instance;

  GetPushNotificationRx({required super.empty, required super.dataFetcher});

  ValueStream<PushNotificationModel> get fileData => dataFetcher.stream;

  Future<bool> fetchPushNotification() async {
    try {
      Map<String, dynamic> data =
          await api.getPushNotificationData() as Map<String, dynamic>;
      PushNotificationModel model = PushNotificationModel.fromJson(data);
      return await handleSuccessWithReturn(model);
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

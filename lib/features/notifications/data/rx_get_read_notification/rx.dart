import 'package:rxdart/rxdart.dart';
import '../../../../helpers/error_message_handler.dart';
import '../../../../networks/rx_base.dart';
import 'api.dart';

final class GetReadNotificationRx extends RxResponseInt {
  final api = GetReadNotificationApi.instance;

  GetReadNotificationRx({required super.empty, required super.dataFetcher});

  ValueStream get fileData => dataFetcher.stream;

  Future<bool> readNotification(String id) async {
    try {
      Map data = await api.getReadNotificationData(id);
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

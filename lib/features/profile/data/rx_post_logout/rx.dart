import 'package:rxdart/rxdart.dart';
import '../../../../helpers/error_message_handler.dart';
import '../../../../networks/rx_base.dart';
import 'api.dart';

final class PostLogoutRx extends RxResponseInt<Map> {
  final api = PostLogoutApi.instance;

  PostLogoutRx({required super.empty, required super.dataFetcher});

  ValueStream<Map> get dataStream => dataFetcher.stream;

  Future<bool> postLogout() async {
    try {
      Map data = await api.postLogout();
      return await handleSuccessWithReturn(data);
    } catch (error) {
      return await handleErrorWithReturn(error);
    }
  }

  @override
  handleSuccessWithReturn(Map data) async {
    dataFetcher.sink.add(data);
    return true;
  }

  @override
  handleErrorWithReturn(error) {
    ErrorMessageHandler.showErrorToast(error);
    return false;
  }
}

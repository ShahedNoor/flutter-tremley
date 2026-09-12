import 'package:rxdart/rxdart.dart';
import '../../../../helpers/error_message_handler.dart';
import '../../../../networks/rx_base.dart';
import 'api.dart';

final class PostDeleteAccountRx extends RxResponseInt<Map> {
  final api = PostDeleteAccountApi.instance;

  PostDeleteAccountRx({required super.empty, required super.dataFetcher});

  ValueStream<Map> get dataStream => dataFetcher.stream;

  Future<bool> postDeleteAccount() async {
    try {
      Map data = await api.postDeleteAccount();
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

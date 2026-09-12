import 'package:rxdart/rxdart.dart';
import '../../../../helpers/error_message_handler.dart';
import '../../../../networks/rx_base.dart';
import 'api.dart';

final class PostChangePasswordRx extends RxResponseInt<Map> {
  final api = PostChangePasswordApi.instance;

  PostChangePasswordRx({required super.empty, required super.dataFetcher});

  ValueStream<Map> get dataStream => dataFetcher.stream;

  Future<bool> postChangePassword({
    required String currentPassword,
    required String newPassword,
    required String email,
  }) async {
    try {
      Map data = await api.postChangePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
        email: email,
      );
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

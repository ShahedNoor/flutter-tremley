import 'package:rxdart/rxdart.dart';
import '../../../../helpers/error_message_handler.dart';
import '../../../../networks/rx_base.dart';
import 'api.dart';

final class PostHelpSupportRx extends RxResponseInt {
  final api = PostHelpSupportApi.instance;

  PostHelpSupportRx({required super.empty, required super.dataFetcher});

  ValueStream get getPostHelpSupportRes => dataFetcher.stream;

  Future<bool> postSupport({
    required String subject,
    required String message,
    required String email,
    required String name,
  }) async {
    try {
      Map data = await api.postSupport(
        subject: subject,
        message: message,
        email: email,
        name: name,
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
    dataFetcher.sink.addError(error);
    ErrorMessageHandler.showErrorToast(error);
    return false;
  }
}

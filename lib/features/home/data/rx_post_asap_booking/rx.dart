import 'package:rxdart/rxdart.dart';
import '../../../../helpers/error_message_handler.dart';
import '../../../../networks/rx_base.dart';
import 'api.dart';

final class PostAsapBookingRx extends RxResponseInt<Map<String, dynamic>> {
  PostAsapBookingRx({required super.empty, required super.dataFetcher});

  ValueStream<Map<String, dynamic>> get stream => dataFetcher.stream;

  Future<bool> postBooking({
    required Map<String, dynamic> data,
  }) async {
    try {
      final res = await PostAsapBookingApi.instance.postBooking(data: data);
      return await handleSuccessWithReturn(res);
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

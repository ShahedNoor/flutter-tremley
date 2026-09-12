import 'package:rxdart/rxdart.dart';
import '../../../../networks/rx_base.dart';
import 'api.dart';

final class PostCustomerBookingRx extends RxResponseInt<Map<String, dynamic>> {
  PostCustomerBookingRx({required super.empty, required super.dataFetcher});

  ValueStream<Map<String, dynamic>> get dataStream => dataFetcher.stream;

  Future<Map<String, dynamic>> postBooking({
    required Map<String, dynamic> data,
  }) async {
    try {
      final res = await PostCustomerBookingApi.instance.postBooking(data: data);
      handleSuccessWithReturn(res);
      return res;
    } catch (error) {
      handleErrorWithReturn(error);
      rethrow;
    }
  }
}

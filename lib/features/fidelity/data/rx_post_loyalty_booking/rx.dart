import 'package:rxdart/rxdart.dart';
import '../../../../networks/rx_base.dart';
import 'api.dart';

final class PostLoyaltyBookingRx extends RxResponseInt<Map<String, dynamic>> {
  PostLoyaltyBookingRx({required super.empty, required super.dataFetcher});

  ValueStream<Map<String, dynamic>> get dataStream => dataFetcher.stream;

  Future<Map<String, dynamic>> postLoyaltyBooking({
    required Map<String, dynamic> data,
  }) async {
    try {
      final res =
          await PostLoyaltyBookingApi.instance.postLoyaltyBooking(data: data);
      handleSuccessWithReturn(res);
      return res;
    } catch (error) {
      handleErrorWithReturn(error);
      rethrow;
    }
  }
}
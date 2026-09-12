import 'package:rxdart/rxdart.dart';
import '../../../../networks/rx_base.dart';
import 'api.dart';

final class GetPaymentStatusRx extends RxResponseInt<Map<String, dynamic>> {
  GetPaymentStatusRx({required super.empty, required super.dataFetcher});

  ValueStream<Map<String, dynamic>> get dataStream => dataFetcher.stream;

  Future<Map<String, dynamic>> getPaymentStatus(int id) async {
    try {
      final res = await GetPaymentStatusApi.instance.getPaymentStatus(id);
      handleSuccessWithReturn(res);
      return res;
    } catch (error) {
      handleErrorWithReturn(error);
      rethrow;
    }
  }
}

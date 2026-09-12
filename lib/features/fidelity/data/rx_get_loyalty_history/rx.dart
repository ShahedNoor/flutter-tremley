import 'package:rxdart/rxdart.dart';
import '../../../../networks/rx_base.dart';
import '../../model/loyalty_history_model.dart';
import 'api.dart';

final class GetLoyaltyHistoryRx extends RxResponseInt<LoyaltyHistoryModel> {
  final api = GetLoyaltyHistoryApi.instance;

  GetLoyaltyHistoryRx({required super.empty, required super.dataFetcher});

  ValueStream<LoyaltyHistoryModel> get getLoyaltyHistoryStream => dataFetcher.stream;

  Future<void> fetchLoyaltyHistory() async {
    try {
      final data = await api.fetchLoyaltyHistory();
      handleSuccessWithReturn(data);
    } catch (error) {
      handleErrorWithReturn(error);
    }
  }

  @override
  handleSuccessWithReturn(dynamic data) {
    LoyaltyHistoryModel response = LoyaltyHistoryModel.fromJson(data);
    dataFetcher.sink.add(response);
    return response;
  }

  @override
  handleErrorWithReturn(dynamic error) {
    dataFetcher.sink.addError(error);
    return empty;
  }

  @override
  void clean() {
    dataFetcher.sink.add(empty);
  }
}

import 'package:rxdart/rxdart.dart';
import '../../../../networks/rx_base.dart';
import '../../model/salon_loyalty_model.dart';
import 'api.dart';

final class GetSalonLoyaltyRx extends RxResponseInt<SalonLoyaltyModel> {
  final api = GetSalonLoyaltyApi.instance;

  GetSalonLoyaltyRx({required super.empty, required super.dataFetcher});

  ValueStream<SalonLoyaltyModel> get getSalonLoyaltyStream =>
      dataFetcher.stream;

  Future<void> fetchSalonLoyalty(String salonId) async {
    try {
      final data = await api.fetchSalonLoyalty(salonId);
      handleSuccessWithReturn(data);
    } catch (error) {
      handleErrorWithReturn(error);
    }
  }

  @override
  handleSuccessWithReturn(dynamic data) {
    SalonLoyaltyModel response = SalonLoyaltyModel.fromJson(data);
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

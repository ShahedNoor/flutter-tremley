import 'package:rxdart/rxdart.dart';
import '../../../../networks/rx_base.dart';
import '../../model/reservation_model.dart';
import 'api.dart';

final class GetReservationsRx extends RxResponseInt<ReservationModel> {
  final api = GetReservationsApi.instance;

  GetReservationsRx({required super.empty, required super.dataFetcher});

  ValueStream<ReservationModel> get getReservationStream => dataFetcher.stream;

  Future<ReservationModel> fetchReservations(String type) async {
    try {
      Map<String, dynamic> data = await api.getReservations(type);
      return handleSuccessWithReturn(data);
    } catch (error) {
      return handleErrorWithReturn(error);
    }
  }

  @override
  ReservationModel handleSuccessWithReturn(dynamic data) {
    ReservationModel model = ReservationModel.fromJson(data);
    dataFetcher.sink.add(model);
    return model;
  }

  @override
  ReservationModel handleErrorWithReturn(dynamic error) {
    dataFetcher.sink.addError(error);
    throw error;
  }
}

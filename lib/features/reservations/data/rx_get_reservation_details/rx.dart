import 'package:rxdart/rxdart.dart';
import '../../../../networks/rx_base.dart';
import '../../model/reservation_details_model.dart';
import 'api.dart';

final class GetReservationDetailsRx
    extends RxResponseInt<ReservationDetailsModel> {
  final api = GetReservationDetailsApi.instance;

  GetReservationDetailsRx({required super.empty, required super.dataFetcher});

  ValueStream<ReservationDetailsModel> get getReservationDetailsStream =>
      dataFetcher.stream;

  Future<ReservationDetailsModel> fetchReservationDetails(int id) async {
    try {
      Map<String, dynamic> data = await api.getReservationDetails(id);
      return handleSuccessWithReturn(data);
    } catch (error) {
      return handleErrorWithReturn(error);
    }
  }

  @override
  ReservationDetailsModel handleSuccessWithReturn(dynamic data) {
    ReservationDetailsModel model = ReservationDetailsModel.fromJson(data);
    dataFetcher.sink.add(model);
    return model;
  }

  @override
  ReservationDetailsModel handleErrorWithReturn(dynamic error) {
    dataFetcher.sink.addError(error);
    throw error;
  }
}

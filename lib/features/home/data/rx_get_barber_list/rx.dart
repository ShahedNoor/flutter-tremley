import 'package:rxdart/rxdart.dart';
import '../../../../helpers/error_message_handler.dart';
import '../../../../networks/rx_base.dart';
import '../../model/barber_list_model.dart';
import 'api.dart';

final class GetBarberListRx extends RxResponseInt<BarberListModel> {
  final api = GetBarberListApi.instance;

  GetBarberListRx({required super.empty, required super.dataFetcher});

  ValueStream<BarberListModel> get dataStream => dataFetcher.stream;

  Future<bool> fetchBarberList(int salonId) async {
    try {
      final Map data = await api.getBarberListData(salonId);
      final BarberListModel model =
          BarberListModel.fromJson(data as Map<String, dynamic>);
      return await handleSuccessWithReturn(model);
    } catch (error) {
      return await handleErrorWithReturn(error);
    }
  }

  @override
  dynamic handleSuccessWithReturn(dynamic data) {
    dataFetcher.sink.add(data as BarberListModel);
    return true;
  }

  @override
  dynamic handleErrorWithReturn(dynamic error) {
    ErrorMessageHandler.showErrorToast(error);
    return false;
  }
}

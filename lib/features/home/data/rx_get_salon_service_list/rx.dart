import 'package:rxdart/rxdart.dart';
import '../../../../helpers/error_message_handler.dart';
import '../../../../networks/rx_base.dart';
import '../../model/service_list_model.dart';
import 'api.dart';

final class GetSalonServiceListRx extends RxResponseInt<ServiceListModel> {
  final api = GetSalonServiceListApi.instance;

  GetSalonServiceListRx({required super.empty, required super.dataFetcher});

  ValueStream<ServiceListModel> get dataStream => dataFetcher.stream;

  Future<bool> fetchSalonServiceList(int salonId) async {
    try {
      final Map data = await api.getSalonServiceListData(salonId);
      final ServiceListModel model =
          ServiceListModel.fromJson(data as Map<String, dynamic>);
      return await handleSuccessWithReturn(model);
    } catch (error) {
      return await handleErrorWithReturn(error);
    }
  }

  @override
  dynamic handleSuccessWithReturn(dynamic data) {
    dataFetcher.sink.add(data as ServiceListModel);
    return true;
  }

  @override
  dynamic handleErrorWithReturn(dynamic error) {
    ErrorMessageHandler.showErrorToast(error);
    return false;
  }
}

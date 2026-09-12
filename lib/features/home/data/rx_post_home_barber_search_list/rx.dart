import 'package:rxdart/rxdart.dart';
import '../../../../helpers/error_message_handler.dart';
import '../../../../networks/rx_base.dart';
import 'api.dart';
import '../../model/home_barber_search_list_model.dart';

final class PostHomeBarberSearchListRx extends RxResponseInt<HomeBarberSearchListModel> {
  PostHomeBarberSearchListRx({required super.empty, required super.dataFetcher});

  ValueStream<HomeBarberSearchListModel> get dataStream => dataFetcher.stream;

  Future<bool> postSearchList({
    required Map<String, dynamic> data,
  }) async {
    try {
      final res = await PostHomeBarberSearchListApi.instance.postSearchList(data: data);
      final model = HomeBarberSearchListModel.fromJson(res);
      return await handleSuccessWithReturn(model);
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

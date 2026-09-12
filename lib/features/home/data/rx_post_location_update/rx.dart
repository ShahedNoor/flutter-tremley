import 'package:rxdart/rxdart.dart';

import '../../../../helpers/error_message_handler.dart';
import '../../../../networks/rx_base.dart';
import 'api.dart';

final class PostLocationUpdateRx extends RxResponseInt<Map> {
  final api = PostLocationUpdateApi.instance;

  PostLocationUpdateRx({required super.empty, required super.dataFetcher});

  ValueStream<Map> get dataStream => dataFetcher.stream;

  Future<bool> postLocationUpdate({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final Map data = await api.postLocationUpdate(
        latitude: latitude,
        longitude: longitude,
      );
      return await handleSuccessWithReturn(data);
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

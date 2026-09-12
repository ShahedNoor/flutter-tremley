import 'package:rxdart/rxdart.dart';
import '../../../../networks/rx_base.dart';
import 'api.dart';

final class PostProfileUpdateRx extends RxResponseInt<Map> {
  final api = PostProfileUpdateApi.instance;

  PostProfileUpdateRx({required super.empty, required super.dataFetcher});

  ValueStream<Map> get dataStream => dataFetcher.stream;

  Future<bool> postProfileUpdate({
    required String name,
    required String email,
    required String phone,
    String? imagePath,
  }) async {
    try {
      Map data = await api.postProfileUpdate(
        name: name,
        email: email,
        phone: phone,
        imagePath: imagePath,
      );
      return handleSuccessWithReturn(data);
    } catch (error) {
      return handleErrorWithReturn(error);
    }
  }

  @override
  handleSuccessWithReturn(Map data) {
    dataFetcher.sink.add(data);
    return true;
  }

  @override
  handleErrorWithReturn(error) {
    dataFetcher.sink.addError(error);
    return false;
  }
}

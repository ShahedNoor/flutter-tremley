import 'package:rxdart/rxdart.dart';
import '../../../../networks/rx_base.dart';
import 'api.dart';

final class PostResendOtpRx extends RxResponseInt<Map> {
  final api = PostResendOtpApi.instance;

  PostResendOtpRx({required super.empty, required super.dataFetcher});

  ValueStream<Map> get dataStream => dataFetcher.stream;

  Future<bool> postResendOtp({required String email}) async {
    try {
      Map data = await api.postResendOtp(email: email);
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

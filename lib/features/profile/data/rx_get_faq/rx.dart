import 'package:rxdart/rxdart.dart';
import '../../../../helpers/error_message_handler.dart';
import '../../../../networks/rx_base.dart';
import '../../model/faq_model.dart';
import 'api.dart';

final class GetFaqRx extends RxResponseInt<FaqModel> {
  final api = GetFaqApi.instance;

  GetFaqRx({required super.empty, required super.dataFetcher});

  ValueStream<FaqModel> get faqData => dataFetcher.stream;

  Future<void> fetchFaq() async {
    try {
      FaqModel data = await api.getFaqData();
      handleSuccessWithReturn(data);
    } catch (error) {
      handleErrorWithReturn(error);
    }
  }

  @override
  handleErrorWithReturn(dynamic error) {
    dataFetcher.sink.addError(error);
    ErrorMessageHandler.showErrorToast(error);
    return null;
  }
}

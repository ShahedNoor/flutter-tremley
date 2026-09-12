import 'package:rxdart/rxdart.dart';
import '../../../../networks/rx_base.dart';
import 'api.dart';

final class PostReviewRx extends RxResponseInt {
  final api = PostReviewApi.instance;

  PostReviewRx({required super.empty, required super.dataFetcher});

  ValueStream get getPostReviewStream => dataFetcher.stream;

  Future<void> postReview(Map<String, dynamic> requestData) async {
    try {
      Map<String, dynamic> data = await api.postReview(requestData);
      handleSuccessWithReturn(data);
    } catch (error) {
      handleErrorWithReturn(error);
    }
  }
}

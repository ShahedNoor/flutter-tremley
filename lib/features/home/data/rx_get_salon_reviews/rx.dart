import 'package:rxdart/rxdart.dart';
import '../../../../helpers/error_message_handler.dart';
import '../../../../networks/rx_base.dart';
import '../../model/salon_reviews_model.dart';
import 'api.dart';

final class GetSalonReviewsRx extends RxResponseInt<SalonReviewsModel> {
  final api = GetSalonReviewsApi.instance;

  GetSalonReviewsRx({required super.empty, required super.dataFetcher});

  ValueStream<SalonReviewsModel> get fileData => dataFetcher.stream;

  Future<bool> fetchSalonReviews(int id, int perPage) async {
    try {
      Map data = await api.getSalonReviews(id, perPage);
      return await handleSuccessWithReturn(
        SalonReviewsModel.fromJson(data as Map<String, dynamic>),
      );
    } catch (error) {
      return await handleErrorWithReturn(error);
    }
  }

  @override
  handleSuccessWithReturn(SalonReviewsModel data) async {
    dataFetcher.sink.add(data);
    return true;
  }

  @override
  handleErrorWithReturn(error) {
    ErrorMessageHandler.showErrorToast(error);
    return false;
  }
}

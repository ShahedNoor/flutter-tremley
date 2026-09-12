import 'dart:developer';
import 'package:rxdart/rxdart.dart';
import '../../../../helpers/error_message_handler.dart';
import '../../../../networks/rx_base.dart';
import '../../model/booking_details_model.dart';
import 'api.dart';

final class GetBookingDetailsRx extends RxResponseInt<BookingDetailsModel> {
  final api = GetBookingDetailsApi.instance;

  GetBookingDetailsRx({required super.empty, required super.dataFetcher});

  ValueStream<BookingDetailsModel> get getBookingDetailsStream =>
      dataFetcher.stream;

  Future<BookingDetailsModel> fetchBookingDetails(int id) async {
    try {
      Map<String, dynamic> data = await api.getBookingDetails(id);
      return handleSuccessWithReturn(data);
    } catch (error) {
      return handleErrorWithReturn(error);
    }
  }

  @override
  BookingDetailsModel handleSuccessWithReturn(dynamic data) {
    BookingDetailsModel res = BookingDetailsModel.fromJson(data);
    log("BookingDetails fetched for ${res.data?.bookingInfo?.id}. Status: ${res.data?.bookingInfo?.status}");
    res.data?.tracking?.forEach((t) {
      log("Tracking: ${t.title} -> ${t.isCompleted}");
    });
    dataFetcher.sink.add(res);
    return res;
  }

  @override
  BookingDetailsModel handleErrorWithReturn(dynamic error) {
    ErrorMessageHandler.showErrorToast(error);
    dataFetcher.sink.addError(error);
    throw error;
  }
}

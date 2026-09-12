import '../../../../networks/rx_base.dart';
import '../../model/booking_slots_model.dart';
import 'api.dart';

final class PostBookingSlotsRx extends RxResponseInt<BookingSlotsModel> {
  PostBookingSlotsRx({required super.empty, required super.dataFetcher});

  Future<void> fetchSlots({
    required String providerType,
    int? salonId,
    required String date,
    int? barberId,
  }) async {
    try {
      BookingSlotsModel data =
          await PostBookingSlotsApi.instance.postBookingSlots(
        providerType: providerType,
        salonId: salonId,
        date: date,
        barberId: barberId,
      );
      handleSuccessWithReturn(data);
    } catch (e) {
      handleErrorWithReturn(e);
    }
  }

  @override
  void handleSuccessWithReturn(BookingSlotsModel data) {
    dataFetcher.sink.add(data);
  }
}

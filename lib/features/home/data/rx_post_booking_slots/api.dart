import '../../../../networks/dio/dio.dart';
import '../../../../networks/endpoints.dart';
import '../../model/booking_slots_model.dart';

final class PostBookingSlotsApi {
  static final PostBookingSlotsApi _singleton = PostBookingSlotsApi._internal();
  PostBookingSlotsApi._internal();
  static PostBookingSlotsApi get instance => _singleton;

  Future<BookingSlotsModel> postBookingSlots({
    required String providerType,
    int? salonId,
    required String date,
    int? barberId,
  }) async {
    try {
      Map<String, dynamic> data = {
        "provider_type": providerType,
        "date": date,
      };
      if (salonId != null) {
        data["salon_id"] = salonId;
      }
      if (barberId != null) {
        data["barber_id"] = barberId;
      }

      final response = await DioSingleton.instance.dio.post(
        Endpoints.bookingSlots(),
        data: data,
      );

      if (response.statusCode == 200) {
        return BookingSlotsModel.fromJson(response.data);
      } else {
        throw Exception("Failed to load slots");
      }
    } catch (e) {
      rethrow;
    }
  }
}

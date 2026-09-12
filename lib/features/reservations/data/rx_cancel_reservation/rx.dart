import 'api.dart';

class CancelReservationRx {
  final api = CancelReservationApi.instance;

  Future<Map<String, dynamic>> cancelReservation(int id) async {
    try {
      final res = await api.cancel(id);
      return res;
    } catch (e) {
      rethrow;
    }
  }
}

final cancelReservationRxObj = CancelReservationRx();

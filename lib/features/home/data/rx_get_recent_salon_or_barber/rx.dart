import 'package:rxdart/rxdart.dart';
import '../../../../networks/rx_base.dart';
import '../../model/salon_or_barber_model.dart';
import 'api.dart';

enum RecentHomeLoadingState { none, search, filter }

final class GetRecentSalonOrBarberRx extends RxResponseInt<SalonOrBarberModel?> {
  final api = GetRecentSalonOrBarberApi.instance;
  
  final BehaviorSubject<RecentHomeLoadingState> loadingState = BehaviorSubject.seeded(RecentHomeLoadingState.none);

  GetRecentSalonOrBarberRx({required super.empty, required super.dataFetcher});

  ValueStream<SalonOrBarberModel?> get dataStream => dataFetcher.stream;

  Future<void> fetchRecentSalonOrBarbers({
    required double latitude,
    required double longitude,
    required String type,
    int perPage = 15,
    RecentHomeLoadingState state = RecentHomeLoadingState.none,
  }) async {
    try {
      if (state != RecentHomeLoadingState.none) {
        loadingState.add(state);
        clean();
      }
      Map data = await api.getRecentSalonOrBarberData(
        latitude: latitude,
        longitude: longitude,
        type: type,
        perPage: perPage,
      );
      handleSuccessWithReturn(
        SalonOrBarberModel.fromJson(data as Map<String, dynamic>),
      );
    } catch (error) {
      handleErrorWithReturn(error);
    }
  }

  @override
  handleSuccessWithReturn(SalonOrBarberModel? data) {
    dataFetcher.sink.add(data);
    loadingState.add(RecentHomeLoadingState.none);
    return data;
  }
  
  @override
  handleErrorWithReturn(dynamic error) {
    loadingState.add(RecentHomeLoadingState.none);
    return super.handleErrorWithReturn(error);
  }
}

import 'package:rxdart/rxdart.dart';
import '../../../../networks/rx_base.dart';
import '../../model/salon_or_barber_model.dart';
import 'api.dart';

enum HomeLoadingState { none, search, filter }

final class GetSalonOrBarberRx extends RxResponseInt<SalonOrBarberModel?> {
  final api = GetSalonOrBarberApi.instance;
  
  final BehaviorSubject<HomeLoadingState> loadingState = BehaviorSubject.seeded(HomeLoadingState.none);

  GetSalonOrBarberRx({required super.empty, required super.dataFetcher});

  ValueStream<SalonOrBarberModel?> get dataStream => dataFetcher.stream;

  Future<void> fetchSalonOrBarbers({
    required double latitude,
    required double longitude,
    required String type,
    String? search,
    double? radius,
    HomeLoadingState state = HomeLoadingState.none,
  }) async {
    try {
      if (state != HomeLoadingState.none) {
        loadingState.add(state);
        clean();
      }
      Map data = await api.getSalonOrBarberData(
        latitude: latitude,
        longitude: longitude,
        type: type,
        search: search,
        radius: radius,
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
    loadingState.add(HomeLoadingState.none);
    return data;
  }
  
  @override
  handleErrorWithReturn(dynamic error) {
    loadingState.add(HomeLoadingState.none);
    return super.handleErrorWithReturn(error);
  }
}

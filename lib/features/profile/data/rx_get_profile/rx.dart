import 'package:rxdart/rxdart.dart';
import '../../../../networks/rx_base.dart';
import '../../model/profile_model.dart';
import '../../../../constants/app_constants.dart';
import '../../../../helpers/di.dart';
import 'api.dart';

final class GetProfileRx extends RxResponseInt<ProfileModel> {
  final api = GetProfileApi.instance;

  GetProfileRx({required super.empty, required super.dataFetcher});

  ValueStream<ProfileModel> get dataStream => dataFetcher.stream;

  Future<void> fetchProfile() async {
    try {
      Map data = await api.getProfile();
      handleSuccessWithReturn(ProfileModel.fromJson(data as Map<String, dynamic>));
    } catch (error) {
      handleErrorWithReturn(error);
    }
  }

  @override
  handleSuccessWithReturn(ProfileModel data) {
    String name = data.data?.user?.name ?? "";
    List<String> nameParts = name.split(" ");
    String firstName = nameParts.isNotEmpty ? nameParts.first : "";
    String lastName = nameParts.length > 1 ? nameParts.sublist(1).join(" ") : "";
    
    appData.write(kKeyFirstName, firstName);
    appData.write(kKeyLastName, lastName);
    
    dataFetcher.sink.add(data);
    return data;
  }
}

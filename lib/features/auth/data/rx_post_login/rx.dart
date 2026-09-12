import 'package:rxdart/rxdart.dart';
import '../../../../helpers/error_message_handler.dart';
import '../../../../helpers/post_login.dart';
import '../../../../constants/app_constants.dart';
import '../../../../helpers/di.dart';
import '../../../../networks/dio/dio.dart';
import '../../../../networks/rx_base.dart';
import 'api.dart';

final class PostLoginRx extends RxResponseInt<Map> {
  final api = PostLoginApi.instance;

  PostLoginRx({required super.empty, required super.dataFetcher});

  ValueStream<Map> get dataStream => dataFetcher.stream;

  Future<bool> postLogin({
    required String email,
    required String password,
  }) async {
    try {
      Map data = await api.postLogin(
        email: email,
        password: password,
      );
      return await handleSuccessWithReturn(data);
    } catch (error) {
      return await handleErrorWithReturn(error);
    }
  }

  @override
  handleSuccessWithReturn(data) async {
    String? accesstoken = data['data']['token'];
    int id = data['data']['user']['id'];
    String email = data['data']['user']['email'];
    String name = data['data']['user']['name'] ?? "";
    List<String> nameParts = name.split(" ");
    String firstName = nameParts.isNotEmpty ? nameParts.first : "";
    String lastName = nameParts.length > 1 ? nameParts.sublist(1).join(" ") : "";
    
    DioSingleton.instance.update(accesstoken!);
    await appData.write(kKeyIsLoggedIn, true);
    await appData.write(kKeyUserID, id);
    await appData.write(kKeyAccessToken, accesstoken);
    await appData.write(kEmail, email);
    await appData.write(kKeyFirstName, firstName);
    await appData.write(kKeyLastName, lastName);
    dataFetcher.sink.add(data);
    await performPostLoginActions();
    return true;
  }

  @override
  handleErrorWithReturn(error) {
    ErrorMessageHandler.showErrorToast(error);
    return false;
  }
}

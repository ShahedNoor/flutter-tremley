import 'package:rxdart/rxdart.dart';
import '../../../../helpers/error_message_handler.dart';
import '../../../../helpers/post_login.dart';
import '../../../../constants/app_constants.dart';
import '../../../../helpers/di.dart';
import '../../../../networks/dio/dio.dart';
import '../../../../networks/rx_base.dart';
import 'api.dart';

final class PostSignupRx extends RxResponseInt<Map> {
  final api = PostSignupApi.instance;

  PostSignupRx({required super.empty, required super.dataFetcher});

  ValueStream<Map> get dataStream => dataFetcher.stream;

  Future<bool> postSignup({
    required String name,
    required String phone,
    required String email,
    required String password,
    required String passwordConfirmation,
    String role = "customer",
    String userType = "customer",
    required String postalCode,
  }) async {
    try {
      Map data = await api.postSignup(
        name: name,
        phone: phone,
        email: email,
        password: password,
        passwordConfirmation: passwordConfirmation,
        role: role,
        userType: userType,
        postalCode: postalCode,
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

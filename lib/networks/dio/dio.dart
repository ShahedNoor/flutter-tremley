import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../endpoints.dart';
import 'log.dart';
import '../../constants/app_constants.dart';
import '../../helpers/di.dart';
import '../../helpers/all_routes.dart';
import '../../helpers/navigation_service.dart';
import '../api_acess.dart';
import '../../common_widgets/custom_toast.dart';

final class DioSingleton {
  static final DioSingleton _singleton = DioSingleton._internal();
  static CancelToken cancelToken = CancelToken();
  DioSingleton._internal();

  static DioSingleton get instance => _singleton;

  late Dio dio;

  void create() {
    BaseOptions options = BaseOptions(
      baseUrl: url,
      connectTimeout: const Duration(milliseconds: 100000),
      receiveTimeout: const Duration(milliseconds: 100000),
      headers: {
        NetworkConstants.ACCEPT: NetworkConstants.ACCEPT_TYPE,
        NetworkConstants.CONTENT_TYPE: NetworkConstants.ACCEPT_TYPE,
      },
    );

    dio = Dio(options)
      ..interceptors.add(Logger())
      ..interceptors.add(InterceptorsWrapper(
        onError: (error, handler) {
          if (_isGlobalError(error)) {
            _handleGlobalError(error);
            return handler.reject(error);
          }
          return handler.next(error);
        },
      ));
  }

  void update(String auth) {
    if (kDebugMode) {
      print("Dio update with auth token");
    }
    BaseOptions options = BaseOptions(
      baseUrl: url,
      responseType: ResponseType.json,
      headers: {
        NetworkConstants.ACCEPT: NetworkConstants.ACCEPT_TYPE,
        NetworkConstants.CONTENT_TYPE: NetworkConstants.ACCEPT_TYPE,
        NetworkConstants.AUTHORIZATION: "Bearer $auth",
      },
      connectTimeout: const Duration(milliseconds: 100000),
      receiveTimeout: const Duration(milliseconds: 100000),
    );

    dio = Dio(options)
      ..interceptors.add(Logger())
      ..interceptors.add(InterceptorsWrapper(
        onError: (error, handler) {
          if (_isGlobalError(error)) {
            _handleGlobalError(error);
            return handler.reject(error);
          }
          return handler.next(error);
        },
      ));
  }

  bool _isGlobalError(DioException error) {
    return error.type == DioExceptionType.connectionError ||
        error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.response?.statusCode == 401 ||
        error.response?.statusCode == 403 ||
        error.response?.statusCode == 500 ||
        error.response?.statusCode == 502 ||
        error.response?.statusCode == 503;
  }

  void _handleGlobalError(DioException error) async {
    if (error.response?.statusCode == 401) {
      if (appData.read(kKeyIsLoggedIn) == true) {
        await appData.write(kKeyAccessToken, "");
        await appData.write(kKeyIsLoggedIn, false);
        await appData.remove(kKeyUserID);
        await appData.remove(kKeyUser);
        await appData.remove(kKeyFirstName);
        await appData.remove(kKeyLastName);

        getProfileRxObj.clean();

        // Re-initialize Dio without token
        create();

        customToastMessage("Session expirée", "Veuillez vous reconnecter.");
        NavigationService.navigateToUntilReplacement(Routes.loginScreen);
      }
    }
  }
}

// Simplified HTTP methods - global errors are already handled by interceptor
Future<Response> postHttp(String path, [dynamic data]) async {
  return DioSingleton.instance.dio.post(
    path,
    data: data,
    cancelToken: DioSingleton.cancelToken,
  );
}

Future<Response> putHttp(String path, [dynamic data]) async {
  return DioSingleton.instance.dio.put(
    path,
    data: data,
    cancelToken: DioSingleton.cancelToken,
  );
}

Future<Response> getHttp(String path, [dynamic data]) async {
  return DioSingleton.instance.dio.get(
    path,
    cancelToken: DioSingleton.cancelToken,
  );
}

Future<Response> deleteHttp(String path, [dynamic data]) async {
  return DioSingleton.instance.dio.delete(
    path,
    data: data,
    cancelToken: DioSingleton.cancelToken,
  );
}

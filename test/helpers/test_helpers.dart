import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tremley_cutomer/helpers/all_routes.dart';
import 'package:tremley_cutomer/helpers/navigation_service.dart';

/// Sets up GetIt with a mock GetStorage for testing.
///
/// Call in `setUp()` before each test group.
Future<void> setUpTestDependencies() async {
  TestWidgetsFlutterBinding.ensureInitialized();

  // Stub the path_provider channel so GetStorage.init() doesn't throw
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(
    const MethodChannel('plugins.flutter.io/path_provider'),
    (MethodCall methodCall) async {
      if (methodCall.method == 'getApplicationDocumentsDirectory') {
        return '/tmp/flutter_test';
      }
      return null;
    },
  );

  await GetStorage.init();

  final GetIt locator = GetIt.instance;
  await locator.reset();
  locator.registerSingleton<GetStorage>(GetStorage());
}

/// Tears down GetIt after tests.
///
/// Call in `tearDown()` after each test group.
Future<void> tearDownTestDependencies() async {
  await GetIt.instance.reset();
}

/// Wraps a widget in the necessary ScreenUtilInit + MaterialApp shell
/// so it can be tested in isolation with proper ScreenUtil, navigation,
/// and routing support.
Widget testableWidget(Widget child) {
  return ScreenUtilInit(
    designSize: const Size(375, 812),
    minTextAdapt: true,
    splitScreenMode: true,
    builder: (_, __) {
      return MaterialApp(
        navigatorKey: NavigationService.navigatorKey,
        onGenerateRoute: RouteGenerator.generateRoute,
        home: child,
      );
    },
  );
}

/// Wraps a widget in a minimal MaterialApp (no ScreenUtil) for testing
/// simple widgets that don't depend on .h/.w/.r/.sp.
Widget simpleTestableWidget(Widget child) {
  return MaterialApp(
    home: Scaffold(body: child),
  );
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';
import 'package:auto_animated/auto_animated.dart';
import 'package:firebase_core/firebase_core.dart';
import 'constants/custom_theme.dart';
import 'features/splash/presentation/splash_screen.dart';
import 'gen/colors.gen.dart';
import 'helpers/all_routes.dart';
import 'helpers/di.dart';
import 'helpers/helper_methods.dart';
import 'helpers/notification_service.dart';
import 'helpers/navigation_service.dart';
import 'networks/dio/dio.dart';
import 'firebase_options.dart';

import 'package:intl/date_symbol_data_local.dart';
import 'package:app_links/app_links.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await NotificationService.initialize();
  await initializeDateFormatting('fr_FR', null);
  //await _requestPermissions();
  await GetStorage.init();
  diSetup();
  // initiInternetChecker();
  // await LocationService.instance.initialize();
  DioSingleton.instance.create();

  _initDeepLinks();

  runApp(const MyApp());
}

void _initDeepLinks() async {
  final appLinks = AppLinks();
  try {
    final initialUri = await appLinks.getInitialLink();
    if (initialUri != null) {
      debugPrint("Initial Deep link received: $initialUri");
    }
  } catch (e) {
    debugPrint("Error reading initial deep link in main: $e");
  }

  appLinks.uriLinkStream.listen((uri) {
    if (uri.path.contains('/payment/status') ||
        uri.path.contains('/payment/success')) {
      debugPrint("Deep link received: $uri");
    }
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    rotation();
    return AnimateIfVisibleWrapper(
      showItemInterval: const Duration(milliseconds: 150),
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (bool didPop, _) async {
          showMaterialDialog(context);
        },
        child: LayoutBuilder(
          builder: (context, constraints) {
            return const UtillScreenMobile();
          },
        ),
      ),
    );
  }
}

class UtillScreenMobile extends StatelessWidget {
  const UtillScreenMobile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (bool didPop, _) async {
            showMaterialDialog(context);
          },
          child: MaterialApp(
            theme: ThemeData(
                unselectedWidgetColor: Colors.white,
                primarySwatch: CustomTheme.kToDark,
                useMaterial3: false,
                scaffoldBackgroundColor: AppColors.cFFFFFF,
                appBarTheme: const AppBarTheme(
                    backgroundColor: AppColors.cFFFFFF, elevation: 0)),
            debugShowCheckedModeBanner: false,
            builder: (context, widget) {
              return MediaQuery(data: MediaQuery.of(context), child: widget!);
            },
            navigatorKey: NavigationService.navigatorKey,
            onGenerateRoute: RouteGenerator.generateRoute,
            onUnknownRoute: (settings) {
              return MaterialPageRoute(
                builder: (context) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    Navigator.of(context).pop();
                  });
                  return const Scaffold(backgroundColor: Colors.transparent);
                },
                settings: settings,
              );
            },
            home: const SplashScreen(),
          ),
        );
      },
    );
  }
}

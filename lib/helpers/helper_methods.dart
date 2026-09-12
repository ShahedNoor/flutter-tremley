// ignore_for_file: use_build_context_synchronously, unused_local_variable, avoid_print

import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:http/http.dart' as http;
import '/helpers/di.dart';
import '../constants/app_constants.dart';
import '../gen/colors.gen.dart';

//final appData = locator.get<GetStorage>();
// final plcaeMarkAddress = locator.get<PlcaeMarkAddress>();
//declared for cart scrren calling bottom shit with this from reorder rx
final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
final GlobalKey<PopupMenuButtonState<String>> popUpGlobalkey =
    GlobalKey<PopupMenuButtonState<String>>();

// Future<String?> networkImageToBase64(String imageUrl) async {
//   http.Response response = await http.get(Uri.parse(imageUrl));
//   final bytes = response.bodyBytes;

//   // ignore: unnecessary_null_comparison
//   return (bytes != null ? base64Encode(bytes) : null);
// }

Future<void> setInitValue() async {
  appData.writeIfNull(kKeyfirstTime, true);
  await appData.writeIfNull(kKeyIsLoggedIn, false);
  await appData.writeIfNull(kKeyIsExploring, false);

  var deviceInfo = DeviceInfoPlugin();
  if (Platform.isIOS) {
    var iosDeviceInfo = await deviceInfo.iosInfo;
    appData.write(
        kKeyDeviceID, iosDeviceInfo.identifierForVendor); // unique ID on iOS
  } else if (Platform.isAndroid) {
    var androidDeviceInfo =
        await deviceInfo.androidInfo; // unique ID on Android
    appData.write(kKeyDeviceID, androidDeviceInfo.id);
  }

  try {
    String? token = await FirebaseMessaging.instance.getToken();
    if (token != null) {
      appData.write(kKeyFCMToken, token);
    }
  } catch (e) {
    // log("Error fetching FCM token: $e");
  }
}

// Future<void> initiInternetChecker() async {
//   InternetConnectionChecker.createInstance(
//           checkTimeout: const Duration(seconds: 1),
//           checkInterval: const Duration(seconds: 2))
//       .onStatusChange
//       .listen((status) {
//     switch (status) {
//       case InternetConnectionStatus.connected:
//         ToastUtil.showShortToast('Data connection is available.');
//         break;
//       case InternetConnectionStatus.disconnected:
//         ToastUtil.showNoInternetToast();
//         break;
//     }
//   });
// }

Future<File> getLocalFile(String filename) async {
  File f = File(filename);
  return f;
}

void showMaterialDialog(
  BuildContext context,
) {
  showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.r),
            ),
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.transparent,
            icon: Icon(
              Icons.exit_to_app_rounded,
              color: AppColors.allPrimaryColor,
              size: 40.sp,
            ),
            title: Text(
              "Quitter l'application ?",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            content: Text(
              "Êtes-vous sûr de vouloir quitter l'application ?",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.black54,
              ),
            ),
            actionsAlignment: MainAxisAlignment.center,
            actionsPadding:
                EdgeInsets.only(bottom: 20.h, left: 16.w, right: 16.w),
            actions: <Widget>[
              customeButton(
                  name: "Non",
                  onCallBack: () {
                    Navigator.of(context).pop(false);
                  },
                  height: 30.sp,
                  minWidth: .3.sw,
                  borderRadius: 30.r,
                  color: const Color(0xffFAEDEC),
                  textStyle: TextStyle(
                    fontSize: 17.sp,
                    color: AppColors.allPrimaryColor,
                    fontWeight: FontWeight.w700,
                  ),
                  context: context),
              customeButton(
                  name: "Oui",
                  onCallBack: () {
                    if (Platform.isAndroid) {
                      SystemNavigator.pop();
                    } else if (Platform.isIOS) {
                      exit(0);
                    }
                  },
                  height: 30.sp,
                  minWidth: .3.sw,
                  borderRadius: 30.r,
                  color: AppColors.allPrimaryColor,
                  textStyle: TextStyle(
                      fontSize: 17.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w700),
                  context: context),
            ],
          ));
}

void rotation() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Color.fromARGB(80, 0, 0, 0),
    statusBarIconBrightness: Brightness.light,
  ));

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}

Widget customeButton({
  required String name,
  required VoidCallback onCallBack,
  required double height,
  required double minWidth,
  required double borderRadius,
  required Color color,
  required TextStyle textStyle,
  required BuildContext context,
  Color? borderColor,
}) {
  return MaterialButton(
    onPressed: onCallBack,
    height: height,
    minWidth: minWidth,
    shape: RoundedRectangleBorder(
      side: BorderSide(
          color: borderColor ?? AppColors.allPrimaryColor, width: 1.5.sp),
      borderRadius: BorderRadius.circular(borderRadius),
    ),
    color: color,
    //splashColor: Colors.white.withOpacity(0.4),
    child: Text(
      name,
      style: textStyle,
    ),
  );
}

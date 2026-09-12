import 'package:tremley_cutomer/constants/app_constants.dart';
import 'package:tremley_cutomer/helpers/di.dart';
import 'package:tremley_cutomer/networks/api_acess.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void>? _fcmSyncInFlight;
String? _lastSyncedFcmSignature;

Future<void> performPostLoginActions() async {
  if (_fcmSyncInFlight != null) {
    await _fcmSyncInFlight;
    return;
  }

  Future<void> syncTask() async {
    try {
      String? currentToken = await FirebaseMessaging.instance.getToken();
      String deviceId = appData.read(kKeyDeviceID) ?? "";

      if (currentToken == null || currentToken.isEmpty || deviceId.isEmpty) {
        return;
      }

      String signature = '$currentToken|$deviceId';
      if (_lastSyncedFcmSignature == signature) {
        return;
      }

      await postFcmTokenRxObj.postFcmToken(
        fcmToken: currentToken,
        deviceId: deviceId,
      );
      await appData.write(kKeyFCMToken, currentToken);
      _lastSyncedFcmSignature = signature;
    } catch (e) {
      // Ignored
    }
  }

  _fcmSyncInFlight = syncTask();
  try {
    await _fcmSyncInFlight;
  } finally {
    _fcmSyncInFlight = null;
  }
}

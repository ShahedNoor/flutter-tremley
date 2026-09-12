import 'dart:convert';
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:tremley_cutomer/constants/app_constants.dart';
import 'package:tremley_cutomer/helpers/di.dart';
import 'package:tremley_cutomer/helpers/navigation_service.dart';
import 'package:tremley_cutomer/networks/api_acess.dart';
import 'package:tremley_cutomer/constants/text_font_style.dart';
import 'package:tremley_cutomer/gen/colors.gen.dart';
import 'package:tremley_cutomer/helpers/ui_helpers.dart';
import 'package:tremley_cutomer/common_widgets/custom_button.dart';
import 'package:vibration/vibration.dart';
import 'package:tremley_cutomer/features/reservations/presentation/reservations_screen.dart';

class NotificationService {
  NotificationService._();

  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static final BehaviorSubject<bool> _permissionStatusSubject =
      BehaviorSubject<bool>.seeded(true);

  static Stream<bool> get permissionStatusStream =>
      _permissionStatusSubject.stream;
  static bool get isCurrentPermissionGranted => _permissionStatusSubject.value;

  static String? activeConversationId;

  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'main_channel',
    'Main Channel',
    description: 'Foreground notifications for the app',
    importance: Importance.high,
  );

  static Future<bool> isPermissionGranted() async {
    try {
      final settings = await _messaging.getNotificationSettings();
      final bool granted =
          settings.authorizationStatus == AuthorizationStatus.authorized ||
              settings.authorizationStatus == AuthorizationStatus.provisional;
      if (_permissionStatusSubject.value != granted) {
        _permissionStatusSubject.add(granted);
      }
      return granted;
    } catch (_) {
      return false;
    }
  }

  static Future<bool> isPermissionDenied() async {
    try {
      final settings = await _messaging.getNotificationSettings();
      return settings.authorizationStatus == AuthorizationStatus.denied;
    } catch (_) {
      return false;
    }
  }

  static Future<bool> requestPermissionWithResult() async {
    try {
      final settings = await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
      final bool granted =
          settings.authorizationStatus == AuthorizationStatus.authorized ||
              settings.authorizationStatus == AuthorizationStatus.provisional;
      _permissionStatusSubject.add(granted);
      if (granted) {
        await syncTokenToBackend();
      }
      return granted;
    } catch (_) {
      return false;
    }
  }

  static Future<void> syncTokenToBackend() async {
    try {
      String? currentToken = await _messaging.getToken();
      String deviceId = appData.read(kKeyDeviceID) ?? "";

      if (currentToken == null || currentToken.isEmpty || deviceId.isEmpty) {
        return;
      }

      await postFcmTokenRxObj.postFcmToken(
        fcmToken: currentToken,
        deviceId: deviceId,
      );
      await appData.write(kKeyFCMToken, currentToken);
    } catch (e) {
      log("Error syncing FCM token: $e");
    }
  }

  static Future<void> requestPermission() async {
    await requestPermissionWithResult();
  }

  static Future<void> initialize() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotificationsPlugin.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        log('Notification tapped: ${response.payload ?? ""}');
        _handlePayload(response.payload);
      },
    );

    final androidPlugin =
        _localNotificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    await androidPlugin?.createNotificationChannel(_channel);

    await _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      final payload = jsonEncode(message.data);
      log('FCM payload: $payload');
      debugPrint('FCM payload: $payload');
      log('FCM notification: ${message.notification?.title ?? ""} | ${message.notification?.body ?? ""}');

      if (message.data.containsKey('booking_id') &&
          message.data.containsKey('status')) {
        try {
          final bookingId = int.tryParse(message.data['booking_id'].toString());
          if (bookingId != null) {
            getBookingDetailsRxObj.fetchBookingDetails(bookingId);
            ReservationsScreenState.instance?.fetchData();
          }
        } catch (e) {
          log("Error updating reservation live status: $e");
        }
      }

      if (message.data.containsKey('points') &&
          message.data['points'] != null) {
        try {
          if (await Vibration.hasVibrator()) {
            Vibration.vibrate(duration: 500, amplitude: 255);
          }
          getLoyaltyHistoryRxObj.clean();
          getLoyaltyHistoryRxObj.fetchLoyaltyHistory();

          final context = NavigationService.context;
          if (context != null) {
            showDialog(
              // ignore: use_build_context_synchronously
              context: context,
              builder: (ctx) => Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.stars,
                          color: AppColors.cFFC107, size: 64),
                      UIHelper.verticalSpace(16),
                      Text(
                        "Félicitations!",
                        style: TextFontStyle.textStyle24c000000InterTight700,
                        textAlign: TextAlign.center,
                      ),
                      UIHelper.verticalSpace(12),
                      Text(
                        "+${double.tryParse(message.data['points'].toString())?.toInt() ?? 0} point ajouté.",
                        style: TextFontStyle.textStyle16c191919InterTight600,
                        textAlign: TextAlign.center,
                      ),
                      UIHelper.verticalSpace(24),
                      CustomButton(
                        onPressed: () => Navigator.pop(ctx),
                        title: "Super",
                        height: 48,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        } catch (e) {
          log("Error showing points popup: $e");
        }
      }

      final notification = message.notification;
      if (notification == null) {
        return;
      }

      // Suppress notification if user is actively viewing this chat
      if (message.data['type'] == 'chat' &&
          message.data['conversation_id'] != null &&
          message.data['conversation_id'] == activeConversationId) {
        log('Notification suppressed: actively viewing conversation $activeConversationId');
        return;
      }

      await showNotification(
        title: notification.title ?? 'Notification',
        body: notification.body ?? '',
        payload: message.data,
      );
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      final payload = jsonEncode(message.data);
      log('FCM opened payload: $payload');
      debugPrint('FCM opened payload: $payload');
      _handlePayload(payload);
    });

    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      final payload = jsonEncode(initialMessage.data);
      log('FCM initial payload: $payload');
      debugPrint('FCM initial payload: $payload');
      _handlePayload(payload);
    }

    // Seed permission status reactively
    isPermissionGranted();
  }

  static Future<void> _handlePayload(String? payload) async {
    if (payload == null || payload.isEmpty) {
      return;
    }

    try {
      final Map<String, dynamic> data =
          Map<String, dynamic>.from(jsonDecode(payload) as Map);
      final String? paymentUrl = data['payment_url']?.toString();

      if (paymentUrl == null || paymentUrl.isEmpty) {
        return;
      }

      final Uri uri = Uri.parse(paymentUrl);
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (error) {
      log('Failed to handle notification payload: $error');
    }
  }

  static Future<void> showNotification({
    required String title,
    required String body,
    Map<String, dynamic>? payload,
  }) async {
    await _localNotificationsPlugin.show(
      id: title.hashCode,
      title: title,
      body: body,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          _channel.id,
          _channel.name,
          channelDescription: _channel.description,
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: const DarwinNotificationDetails(),
      ),
      payload: payload == null ? null : jsonEncode(payload),
    );
  }
}

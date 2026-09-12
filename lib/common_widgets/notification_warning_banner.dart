import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';

import '../constants/text_font_style.dart';
import '../gen/colors.gen.dart';
import '../helpers/notification_service.dart';
import '../helpers/ui_helpers.dart';

class NotificationWarningBanner extends StatefulWidget {
  const NotificationWarningBanner({super.key});

  @override
  State<NotificationWarningBanner> createState() =>
      _NotificationWarningBannerState();
}

class _NotificationWarningBannerState extends State<NotificationWarningBanner>
    with WidgetsBindingObserver {
  bool _isDismissed = false;
  bool _isPermissionDenied = false;
  StreamSubscription<bool>? _permissionSub;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkPermission();
    _permissionSub =
        NotificationService.permissionStatusStream.listen((isGranted) {
      if (mounted) {
        setState(() {
          _isPermissionDenied = !isGranted;
        });
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkPermission();
    }
  }

  Future<void> _checkPermission() async {
    final bool isGranted = await NotificationService.isPermissionGranted();
    if (mounted) {
      setState(() {
        _isPermissionDenied = !isGranted;
      });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _permissionSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool shouldShow = !_isDismissed && _isPermissionDenied;

    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: shouldShow
          ? Container(
              margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: AppColors.allPrimaryColor.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(14.r),
                border: Border.all(
                  color: AppColors.allPrimaryColor.withValues(alpha: 0.25),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(6.r),
                    decoration: BoxDecoration(
                      color: AppColors.allPrimaryColor.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.notifications_off_outlined,
                      color: AppColors.allPrimaryColor,
                      size: 16.sp,
                    ),
                  ),
                  UIHelper.horizontalSpace(10.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Notifications désactivées",
                          style:
                              TextFontStyle.textStyle14c191919Inter600.copyWith(
                            fontSize: 13.sp,
                            color: AppColors.c191919,
                          ),
                        ),
                        Text(
                          "Activez-les pour recevoir vos liens de paiement",
                          style:
                              TextFontStyle.textStyle12c737373Inter400.copyWith(
                            fontSize: 11.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                  UIHelper.horizontalSpace(8.w),
                  GestureDetector(
                    onTap: () async {
                      final granted =
                          await NotificationService.requestPermissionWithResult();
                      if (!granted) {
                        await Geolocator.openAppSettings();
                      }
                      _checkPermission();
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        color: AppColors.allPrimaryColor,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        "Activer",
                        style:
                            TextFontStyle.textStyle12c737373Inter400.copyWith(
                          color: AppColors.cFFFFFF,
                          fontWeight: FontWeight.w600,
                          fontSize: 12.sp,
                        ),
                      ),
                    ),
                  ),
                  UIHelper.horizontalSpace(4.w),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isDismissed = true;
                      });
                    },
                    child: Padding(
                      padding: EdgeInsets.all(4.r),
                      child: Icon(
                        Icons.close,
                        size: 16.sp,
                        color: AppColors.c737373,
                      ),
                    ),
                  ),
                ],
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}

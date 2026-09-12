import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../constants/app_constants.dart';
import '../../../constants/text_font_style.dart';
import '../../../gen/assets.gen.dart';
import '../../../gen/colors.gen.dart';
import '../../../helpers/ui_helpers.dart';
import '../../../helpers/navigation_service.dart';
import '../../../helpers/all_routes.dart';
import '../../../helpers/notification_service.dart';
import '../../../networks/api_acess.dart';
import '../../../helpers/loading_helper.dart';
import '../../../helpers/di.dart';
import '../../../common_widgets/custom_button.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with WidgetsBindingObserver {
  bool _pushEnabled = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkNotificationStatus();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkNotificationStatus();
    }
  }

  Future<void> _checkNotificationStatus() async {
    final isGranted = await Permission.notification.isGranted;
    if (mounted) {
      setState(() {
        _pushEnabled = isGranted;
      });
    }
  }

  Future<void> _handlePushToggle(bool value) async {
    if (value) {
      final status = await Permission.notification.status;
      if (status.isPermanentlyDenied) {
        await openAppSettings();
      } else {
        final result = await Permission.notification.request();
        if (result.isGranted) {
          await FirebaseMessaging.instance
              .setForegroundNotificationPresentationOptions(
            alert: true,
            badge: true,
            sound: true,
          );
          await NotificationService.syncTokenToBackend();
        }
      }
    } else {
      await openAppSettings();
    }
    await _checkNotificationStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cFFFFFF,
      appBar: AppBar(
        backgroundColor: AppColors.cFFFFFF,
        elevation: 0,
        centerTitle: true,
        leading: Padding(
          padding: EdgeInsets.only(left: UIHelper.kDefaulutPadding()),
          child: IconButton(
            onPressed: () => Navigator.pop(context),
            padding: EdgeInsets.zero,
            icon: Assets.icons.arrowBackBlack.image(
              width: 24.r,
              height: 24.r,
              fit: BoxFit.contain,
            ),
          ),
        ),
        title: Text(
          "Paramètres",
          style: TextFontStyle.textStyle24c000000InterTight700
              .copyWith(fontSize: 22.sp),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(UIHelper.kDefaulutPadding()),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle("Notifications"),
            UIHelper.verticalSpace(12.h),
            Container(
              decoration: BoxDecoration(
                color: AppColors.cFFFFFF,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: AppColors.cF2F2F2),
              ),
              child: _buildSwitchTile(
                icon: Assets.icons.pushNotificatonOutlinedGolden,
                title: "Notifications push",
                value: _pushEnabled,
                onChanged: _handlePushToggle,
              ),
            ),
            UIHelper.verticalSpace(24.h),
            _buildSectionTitle("Préférences"),
            UIHelper.verticalSpace(12.h),
            _buildSettingItem(
              icon: Assets.icons.languageOutlinedGolden,
              title: "Langue",
              trailingText: "Français",
              onTap: () {},
            ),
            UIHelper.verticalSpace(24.h),
            _buildSectionTitle("Sécurité"),
            UIHelper.verticalSpace(12.h),
            _buildSettingItem(
              icon: Assets.icons.securityOutlinedGolden,
              title: "Modifier le mot de passe",
              onTap: () {
                NavigationService.navigateTo(Routes.changePasswordScreen);
              },
            ),
            UIHelper.verticalSpace(24.h),
            _buildSectionTitle("Compte"),
            UIHelper.verticalSpace(12.h),
            _buildSettingItem(
              icon: Assets.icons.deleteOutlinedBlack,
              title: "Supprimer le compte",
              isDestructive: true,
              onTap: () => _showDeleteAccountDialog(context),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        child: Padding(
          padding: EdgeInsets.all(24.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(16.r),
                decoration: const BoxDecoration(
                  color: Color(0xFFFEE2E2),
                  shape: BoxShape.circle,
                ),
                child: Assets.icons.deleteOutlinedBlack.image(
                  width: 32.r,
                  height: 32.r,
                  color: const Color(0xFFEF4444),
                ),
              ),
              UIHelper.verticalSpace(20.h),
              Text(
                "Supprimer le compte",
                style: TextFontStyle.textStyle20c222222InterTight600,
              ),
              UIHelper.verticalSpace(12.h),
              Text(
                "Êtes-vous sûr de vouloir supprimer votre compte ? Cette action est irréversible et toutes vos données seront perdues.",
                style: TextFontStyle.textStyle14c8A8A8AInter400,
                textAlign: TextAlign.center,
              ),
              UIHelper.verticalSpace(24.h),
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      onPressed: () => NavigationService.goBackCall(),
                      title: "Annuler",
                      backgroundColor: AppColors.cF2F2F2,
                      foregroundColor: AppColors.c191919,
                      height: 48.h,
                    ),
                  ),
                  UIHelper.horizontalSpace(12.w),
                  Expanded(
                    child: CustomButton(
                      onPressed: () async {
                        NavigationService.goBackCall(); // Close dialog
                        bool success = await postDeleteAccountRxObj
                            .postDeleteAccount()
                            .waitingForFutureWithoutBg();
                        if (success) {
                          await appData.write(kKeyAccessToken, "");
                          await appData.write(kKeyIsLoggedIn, false);
                          NavigationService.navigateToUntilReplacement(
                              Routes.loginScreen);
                        }
                      },
                      title: "Supprimer",
                      backgroundColor: const Color(0xFFEF4444),
                      height: 48.h,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(title, style: TextFontStyle.textStyle16c222222InterTight600);
  }

  Widget _buildSwitchTile({
    required AssetGenImage icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: AppColors.cF7F5F0,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: icon.image(width: 20.w, height: 20.w, fit: BoxFit.contain),
          ),
          UIHelper.horizontalSpace(16.w),
          Expanded(
            child: Text(
              title,
              style: TextFontStyle.textStyle15c222222InterTight500,
            ),
          ),
          CupertinoSwitch(
            value: value,
            activeTrackColor: AppColors.cB08D2A,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem({
    AssetGenImage? icon,
    IconData? iconData,
    required String title,
    String? trailingText,
    bool isDestructive = false,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: AppColors.cFFFFFF,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.cF2F2F2),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color:
                    isDestructive ? const Color(0xFFFEE2E2) : AppColors.cF7F5F0,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: iconData != null
                  ? Icon(
                      iconData,
                      size: 20.w,
                      color: isDestructive
                          ? const Color(0xFFEF4444)
                          : AppColors.cB08D2A,
                    )
                  : icon!.image(
                      width: 20.w,
                      height: 20.w,
                      fit: BoxFit.contain,
                      color: isDestructive ? const Color(0xFFEF4444) : null,
                    ),
            ),
            UIHelper.horizontalSpace(16.w),
            Expanded(
              child: Text(
                title,
                style: TextFontStyle.textStyle15c222222InterTight500.copyWith(
                  color: isDestructive ? const Color(0xFFEF4444) : null,
                ),
              ),
            ),
            if (trailingText != null) ...[
              Text(
                trailingText,
                style: TextFontStyle.textStyle14c8A8A8AInter400.copyWith(
                  color: AppColors.c000000.withValues(alpha: 0.3),
                ),
              ),
              UIHelper.horizontalSpace(8.w),
            ],
            Assets.icons.arrowRightBlack.image(width: 14.w, height: 14.w),
          ],
        ),
      ),
    );
  }
}

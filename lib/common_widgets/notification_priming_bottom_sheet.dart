import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/app_constants.dart';
import '../constants/text_font_style.dart';
import '../gen/colors.gen.dart';
import '../helpers/di.dart';
import '../helpers/notification_service.dart';
import '../helpers/ui_helpers.dart';
import 'custom_button.dart';

class NotificationPrimingBottomSheet extends StatelessWidget {
  final VoidCallback? onCompleted;

  const NotificationPrimingBottomSheet({
    super.key,
    this.onCompleted,
  });

  static Future<void> checkAndShow(BuildContext context) async {
    final bool alreadyPrompted =
        appData.read(kKeyNotificationPrompted) == true;
    if (alreadyPrompted) {
      return;
    }

    final bool isGranted = await NotificationService.isPermissionGranted();
    if (isGranted) {
      return;
    }

    if (!context.mounted) return;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const NotificationPrimingBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: AppColors.cFFFFFF,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Drag handle
          Container(
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: AppColors.cE3E3E3,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          UIHelper.verticalSpace(20.h),

          // Double concentric ring icon badge
          Container(
            width: 80.r,
            height: 80.r,
            decoration: BoxDecoration(
              color: AppColors.allPrimaryColor.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Container(
                width: 58.r,
                height: 58.r,
                decoration: BoxDecoration(
                  color: AppColors.allPrimaryColor.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    Icons.notifications_active_rounded,
                    size: 32.sp,
                    color: AppColors.allPrimaryColor,
                  ),
                ),
              ),
            ),
          ),
          UIHelper.verticalSpace(18.h),

          // Title
          Text(
            "Restez informé de vos réservations",
            textAlign: TextAlign.center,
            style: TextFontStyle.textStyle20c191919Inter600.copyWith(
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          UIHelper.verticalSpace(8.h),

          // Subtitle
          Text(
            "Activez les notifications pour recevoir vos liens de paiement sécurisés et suivre vos rendez-vous.",
            textAlign: TextAlign.center,
            style: TextFontStyle.textStyle14c737373Inter400.copyWith(
              height: 1.45,
            ),
          ),
          UIHelper.verticalSpace(22.h),

          // Benefit cards
          _buildBenefitCard(
            icon: Icons.payment_rounded,
            title: "Liens de paiement sécurisés",
            subtitle:
                "Recevez votre lien de paiement instantanément après la prestation.",
          ),
          UIHelper.verticalSpace(10.h),
          _buildBenefitCard(
            icon: Icons.alarm_on_rounded,
            title: "Rappels de rendez-vous",
            subtitle:
                "Ne manquez aucun créneau grâce à nos notifications automatiques.",
          ),
          UIHelper.verticalSpace(10.h),
          _buildBenefitCard(
            icon: Icons.directions_car_filled_rounded,
            title: "Suivi en temps réel",
            subtitle:
                "Soyez alerté dès que votre barbier est en route à domicile.",
          ),
          UIHelper.verticalSpace(26.h),

          // Primary Button: Enable notifications
          CustomButton(
            onPressed: () async {
              await appData.write(kKeyNotificationPrompted, true);
              if (context.mounted) {
                Navigator.of(context).pop();
              }
              await NotificationService.requestPermissionWithResult();
              onCompleted?.call();
            },
            title: "Activer les notifications",
            height: 50.h,
            backgroundColor: AppColors.allPrimaryColor,
            foregroundColor: AppColors.cFFFFFF,
            textStyle: TextFontStyle.textStyle16c191919Inter600.copyWith(
              color: AppColors.cFFFFFF,
              fontWeight: FontWeight.w600,
            ),
            borderRadius: BorderRadius.circular(12.r),
          ),
          UIHelper.verticalSpace(10.h),

          // Secondary Button: Not now
          CustomButton(
            onPressed: () async {
              await appData.write(kKeyNotificationPrompted, true);
              if (context.mounted) {
                Navigator.of(context).pop();
              }
              onCompleted?.call();
            },
            title: "Plus tard",
            height: 48.h,
            backgroundColor: AppColors.cF4F4F4,
            foregroundColor: AppColors.c191919,
            textStyle: TextFontStyle.textStyle14c191919Inter500.copyWith(
              fontWeight: FontWeight.w600,
            ),
            borderRadius: BorderRadius.circular(12.r),
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: AppColors.cF4F4F4,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.r),
            decoration: const BoxDecoration(
              color: AppColors.cFFFFFF,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 18.sp,
              color: AppColors.allPrimaryColor,
            ),
          ),
          UIHelper.horizontalSpace(12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextFontStyle.textStyle14c191919Inter600.copyWith(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextFontStyle.textStyle12c737373Inter400,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

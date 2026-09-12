import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../constants/text_font_style.dart';
import '../../../../../gen/colors.gen.dart';
import '../../../../../helpers/ui_helpers.dart';

class NotificationItemCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String time;
  final IconData icon;
  final bool isUnread;

  const NotificationItemCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.icon,
    this.isUnread = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: isUnread ? const Color(0xFFFCFAF5) : AppColors.cFFFFFF,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isUnread
              ? AppColors.cB08D2A.withValues(alpha: 0.3)
              : AppColors.cF2F2F2,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.c000000.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                height: 48.r,
                width: 48.r,
                decoration: BoxDecoration(
                  color: isUnread ? AppColors.cFBF4E0 : AppColors.cF2F2F2,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: isUnread ? AppColors.cB08D2A : AppColors.c8A8A8A,
                  size: 24.r,
                ),
              ),
              if (isUnread)
                Positioned(
                  top: 0,
                  right: 2.r,
                  child: Container(
                    height: 12.r,
                    width: 12.r,
                    decoration: BoxDecoration(
                      color: AppColors.cB08D2A,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.cFFFFFF,
                        width: 2.5.r,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          UIHelper.horizontalSpace(16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style:
                            TextFontStyle.textStyle16c191919Inter600.copyWith(
                          fontSize: 16.sp,
                        ),
                      ),
                    ),
                    UIHelper.horizontalSpace(4.w),
                    Text(
                      time,
                      style: TextFontStyle.textStyle12c16A34AInterTight600
                          .copyWith(
                        color: AppColors.c8A8A8A,
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
                UIHelper.verticalSpace(4.h),
                Text(
                  subtitle,
                  style: TextFontStyle.textStyle14c8A8A8AInter500.copyWith(
                    color: AppColors.c737373,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

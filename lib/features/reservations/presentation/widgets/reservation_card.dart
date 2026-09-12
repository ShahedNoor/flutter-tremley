import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../constants/text_font_style.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../gen/colors.gen.dart';
import '../../../../helpers/ui_helpers.dart';

class ReservationCard extends StatelessWidget {
  final String serviceName;
  final String status;
  final Color statusColor;
  final Color statusBgColor;
  final bool isAtSalon;
  final String location;
  final String date;
  final String buttonText;
  final VoidCallback onTap;

  const ReservationCard({
    super.key,
    required this.serviceName,
    required this.status,
    required this.statusColor,
    required this.statusBgColor,
    required this.isAtSalon,
    required this.location,
    required this.date,
    required this.buttonText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.cFFFFFF,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.cF2F2F2),
        boxShadow: [
          BoxShadow(
            color: AppColors.c000000.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  serviceName,
                  style: TextFontStyle.textStyle16c191919InterTight600,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              UIHelper.horizontalSpace(8.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: statusBgColor,
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Text(
                  status,
                  style: TextFontStyle.textStyle12c16A34AInterTight600.copyWith(
                    color: statusColor,
                    fontSize: 11.sp,
                  ),
                ),
              ),
            ],
          ),
          UIHelper.verticalSpace(8.h),
          Row(
            children: [
              isAtSalon
                  ? Assets.icons.scissorsGrey.image(
                      width: 14.sp,
                      height: 14.sp,
                    )
                  : Image.asset(
                      'assets/icons/home_outlined_grey.png',
                      width: 14.sp,
                      height: 14.sp,
                    ),
              UIHelper.horizontalSpace(6.w),
              Text(
                isAtSalon ? "Au salon" : "À domicile",
                style: TextFontStyle.textStyle12c8A8A8AInter500,
              ),
            ],
          ),
          UIHelper.verticalSpace(12.h),
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: AppColors.cF9F9F9,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Column(
              children: [
                _buildInfoRow(
                  isAtSalon
                      ? Assets.icons.navigationBarHomeGrey.image()
                      : Assets.icons.locationOutlinedGrey.image(),
                  location,
                ),
                UIHelper.verticalSpace(8.h),
                _buildInfoRow(
                  Assets.icons.navigationBarCalendarGrey.image(),
                  date,
                ),
              ],
            ),
          ),
          UIHelper.verticalSpace(12.h),
          InkWell(
            onTap: onTap,
            child: Row(
              children: [
                Text(
                  buttonText,
                  style: TextFontStyle.textStyle14cB08D2AInterTight600
                      .copyWith(fontSize: 13.sp),
                ),
                UIHelper.horizontalSpace(4.w),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 12.sp,
                  color: AppColors.cB08D2A,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(Widget icon, String text) {
    return Row(
      children: [
        SizedBox(
          width: 14.sp,
          height: 14.sp,
          child: icon,
        ),
        UIHelper.horizontalSpace(8.w),
        Expanded(
          child: Text(
            text,
            style: TextFontStyle.textStyle13c191919Inter400.copyWith(
              color: AppColors.c4D4D4D,
            ),
          ),
        ),
      ],
    );
  }
}

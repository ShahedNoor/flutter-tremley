import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../constants/text_font_style.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../gen/colors.gen.dart';
import '../../../../helpers/ui_helpers.dart';

class ReservationSummaryCard extends StatelessWidget {
  final String status;
  final String serviceName;
  final String locationType;
  final String salonName;
  final String dateTime;
  final String price;

  const ReservationSummaryCard({
    super.key,
    this.status = "Confirmée",
    this.serviceName = "",
    this.locationType = "",
    this.salonName = "",
    this.dateTime = "",
    this.price = "",
  });

  @override
  Widget build(BuildContext context) {
    Color statusColor = UIHelper.getStatusColor(status);
    Color bgColor = UIHelper.getStatusBgColor(status);

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.cFFFFFF,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.cF2F2F2),
        boxShadow: [
          BoxShadow(
            color: AppColors.c000000.withValues(alpha: 0.04),
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
                  style: TextFontStyle.textStyle16c191919Inter600.copyWith(
                    fontSize: 18.sp,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              UIHelper.horizontalSpace(12.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Text(
                  status,
                  style: TextFontStyle.textStyle12c16A34AInterTight600.copyWith(
                    fontSize: 12.sp,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
          UIHelper.verticalSpace(8.h),
          Row(
            children: [
              Assets.icons.scissorsGrey.image(
                width: 16.w,
                height: 16.w,
              ),
              UIHelper.horizontalSpace(8.w),
              Text(
                locationType,
                style: TextFontStyle.textStyle14c8A8A8AInter500,
              ),
            ],
          ),
          UIHelper.verticalSpace(16.h),
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: AppColors.cF9F9F9,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Column(
              children: [
                _buildInfoRow(
                  Assets.icons.storeOutlinedGolden.image(
                    width: 14.w,
                    height: 14.w,
                  ),
                  salonName,
                ),
                UIHelper.verticalSpace(12.h),
                _buildInfoRow(
                  Assets.icons.calendarSimpleOutlinedGolden.image(
                    width: 14.w,
                    height: 14.w,
                  ),
                  dateTime,
                ),
              ],
            ),
          ),
          UIHelper.verticalSpace(16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total à payer",
                style: TextFontStyle.textStyle16c191919InterTight600,
              ),
              Text(
                price.endsWith('€') ? price : "$price €",
                style: TextFontStyle.textStyle16c191919InterTight600.copyWith(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(Widget icon, String text) {
    return Row(
      children: [
        SizedBox(
          width: 18.w,
          height: 18.w,
          child: icon,
        ),
        UIHelper.horizontalSpace(12.w),
        Expanded(
          child: Text(
            text,
            style: TextFontStyle.textStyle14c191919Inter500.copyWith(
              color: AppColors.c4D4D4D,
            ),
          ),
        ),
      ],
    );
  }
}

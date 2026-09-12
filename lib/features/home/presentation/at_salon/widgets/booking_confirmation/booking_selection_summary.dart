import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tremley_cutomer/constants/text_font_style.dart';
import 'package:tremley_cutomer/gen/assets.gen.dart';
import 'package:tremley_cutomer/gen/colors.gen.dart';
import 'package:tremley_cutomer/helpers/ui_helpers.dart';

class BookingSelectionSummary extends StatelessWidget {
  final String salonName;
  final String serviceName;
  final String duration;
  final String dateTime;
  final String price;

  const BookingSelectionSummary({
    super.key,
    required this.salonName,
    required this.serviceName,
    required this.duration,
    required this.dateTime,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: AppColors.cFFFFFF,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.cEEEEEE),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSummaryItem(Assets.icons.storeOutlinedGolden, salonName),
          UIHelper.verticalSpace(16.h),
          _buildSummaryItem(
              Assets.icons.scissorsOutlinedGolden, "$serviceName ($duration)"),
          UIHelper.verticalSpace(16.h),
          _buildSummaryItem(Assets.icons.calendarOutlinedGolden, dateTime),
          UIHelper.verticalSpace(16.h),
          const Divider(color: AppColors.cF2F2F2, thickness: 1),
          UIHelper.verticalSpace(16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total à payer",
                style: TextFontStyle.textStyle16c1B1B1BInterTight600,
              ),
              Text(
                price,
                style: TextFontStyle.textStyle16c1B1B1BInterTight600,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(AssetGenImage icon, String text) {
    return Row(
      children: [
        Container(
          width: 36.r,
          height: 36.r,
          decoration: BoxDecoration(
            color: AppColors.cFFFFFF,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: AppColors.cF2F2F2),
          ),
          child: Center(
            child: icon.image(width: 18.r, height: 18.r),
          ),
        ),
        UIHelper.horizontalSpace(12.w),
        Expanded(
          child: Text(
            text,
            style: TextFontStyle.textStyle16c1B1B1BInterTight500,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

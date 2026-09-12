import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tremley_cutomer/common_widgets/app_network_image.dart';
import 'package:tremley_cutomer/constants/text_font_style.dart';
import 'package:tremley_cutomer/gen/assets.gen.dart';
import 'package:tremley_cutomer/gen/colors.gen.dart';
import 'package:tremley_cutomer/helpers/ui_helpers.dart';

class BookingSummaryCard extends StatelessWidget {
  final String salonName;
  final String serviceName;
  final String duration;
  final String price;
  final String barberName;
  final String barberImage;
  final double barberRating;

  const BookingSummaryCard({
    super.key,
    required this.salonName,
    required this.serviceName,
    required this.duration,
    required this.price,
    required this.barberName,
    required this.barberImage,
    required this.barberRating,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.cF6F6F6,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.cB08D2A, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Prestation sélectionnée",
              style: TextFontStyle.textStyle16c8A8A8AInter500),
          UIHelper.verticalSpace(8.h),
          Text(salonName, style: TextFontStyle.textStyle18c191919Inter700),
          UIHelper.verticalSpace(12.h),
          Row(
            children: [
              Assets.icons.scissorsGrey.image(width: 18.r, height: 18.r),
              UIHelper.horizontalSpace(8.w),
              Expanded(
                child: Text("$serviceName ($duration)",
                    style: TextFontStyle.textStyle16c191919Inter400),
              ),
              Text(price, style: TextFontStyle.textStyle16c191919Inter700),
            ],
          ),
          UIHelper.verticalSpace(16.h),
          Container(
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color: AppColors.cFFFFFF,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                  color: AppColors.cFFFFFF.withValues(alpha: 0.8), width: 1),
            ),
            child: Row(
              children: [
                AppNetworkImage(
                  width: 50.r,
                  height: 50.r,
                  imageUrl: barberImage,
                  isProfilePicture: true,
                ),
                UIHelper.horizontalSpace(12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Votre barbier",
                        style: TextFontStyle.textStyle14c8A8A8AInter400
                            .copyWith(fontSize: 13.sp),
                      ),
                      Text(
                        barberName,
                        style:
                            TextFontStyle.textStyle16c191919Inter600.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Assets.icons.starYellow.image(width: 16.r, height: 16.r),
                    UIHelper.horizontalSpace(4.w),
                    Text(barberRating.toString(),
                        style: TextFontStyle.textStyle13c222222Inter500),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

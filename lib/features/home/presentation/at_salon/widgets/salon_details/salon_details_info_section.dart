import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tremley_cutomer/constants/text_font_style.dart';
import 'package:tremley_cutomer/gen/assets.gen.dart';
import 'package:tremley_cutomer/gen/colors.gen.dart';
import 'package:tremley_cutomer/helpers/ui_helpers.dart';

class SalonDetailsInfoSection extends StatelessWidget {
  final String name;
  final double rating;
  final String address;
  final double distance;
  final String openingTime;
  final String closingTime;
  final int barbersCount;
  final String description;

  const SalonDetailsInfoSection({
    super.key,
    required this.name,
    required this.rating,
    required this.address,
    required this.distance,
    required this.openingTime,
    required this.closingTime,
    required this.barbersCount,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                name,
                style: TextFontStyle.textStyle20c191919Inter600.copyWith(
                  fontSize: 26.sp,
                  fontWeight: FontWeight.w700,
                  height: 1.2,
                ),
              ),
            ),
            UIHelper.horizontalSpace(12.w),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: AppColors.cF6F6F6,
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Assets.icons.reviewStarGolden.image(
                    width: 16.r,
                    height: 16.r,
                  ),
                  UIHelper.horizontalSpace(6.w),
                  Text(
                    rating.toString(),
                    style: TextFontStyle.textStyle14c1B1B1BInterTight600,
                  ),
                ],
              ),
            ),
          ],
        ),
        UIHelper.verticalSpace(12.h),
        Row(
          children: [
            Assets.icons.locationOutlinedGolden.image(
              width: 20.r,
              height: 20.r,
            ),
            UIHelper.horizontalSpace(8.w),
            Expanded(
              child: Text(
                "$address • $distance km",
                style: TextFontStyle.textStyle14c4D4D4DInterTight500.copyWith(
                  fontSize: 15.sp,
                  color: const Color(0xFF8A8A8A),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        UIHelper.verticalSpace(16.h),
        Row(
          children: [
            _buildInfoTag(
              icon: Assets.icons.clockOutlinedBlack,
              text: "$openingTime - $closingTime",
            ),
            UIHelper.horizontalSpace(12.w),
            // Reusing clock icon for barbers for now or using text only if no icon
            _buildInfoTag(
              icon: Assets.icons
                  .barbersBlack, // Using similar weight icon if no scissors
              text: "$barbersCount barbers",
            ),
          ],
        ),
        UIHelper.verticalSpace(12.h),
        Text(description, style: TextFontStyle.textStyle14c8A8A8AInter400),
      ],
    );
  }

  Widget _buildInfoTag({required AssetGenImage icon, required String text}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
          color: AppColors.cB08D2A
              .withValues(alpha: 0.20), // Light golden-greyish tint
          borderRadius: BorderRadius.circular(100.r),
          border: Border.all(color: AppColors.cB08D2A.withValues(alpha: 0.40))),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon.image(
            width: 12.r,
          ),
          UIHelper.horizontalSpace(6.w),
          Text(
            text,
            style: TextFontStyle.textStyle14c1B1B1BInterTight600.copyWith(
              fontSize: 13.sp,
            ),
          ),
        ],
      ),
    );
  }
}

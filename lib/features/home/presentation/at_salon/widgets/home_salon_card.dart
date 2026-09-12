import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tremley_cutomer/common_widgets/app_network_image.dart';
import 'package:tremley_cutomer/constants/text_font_style.dart';
import 'package:tremley_cutomer/gen/assets.gen.dart';
import 'package:tremley_cutomer/gen/colors.gen.dart';
import 'package:tremley_cutomer/helpers/ui_helpers.dart';

class HomeSalonCard extends StatelessWidget {
  final String name;
  final double rating;
  final int reviewCount;
  final String distance;
  final String address;
  final String status;
  final String closingTime;
  final String imageUrl;
  final VoidCallback onTap;

  const HomeSalonCard({
    super.key,
    required this.name,
    required this.rating,
    this.reviewCount = 0,
    required this.distance,
    required this.address,
    required this.status,
    required this.closingTime,
    required this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cFFFFFF,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: AppColors.cEEEEEE),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: AppNetworkImage(
                imageUrl: imageUrl,
                height: double.infinity,
                width: double.infinity,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          name,
                          style: TextFontStyle.textStyle20c191919Inter600
                              .copyWith(fontSize: 14.sp),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  UIHelper.verticalSpace(4.h),
                  Row(
                    children: [
                      Assets.icons.reviewStarGolden.image(
                        width: 14.r,
                        height: 14.r,
                      ),
                      UIHelper.horizontalSpace(4.w),
                      Text(
                        rating > 0 ? rating.toStringAsFixed(1) : "Nouveau",
                        style: TextFontStyle.textStyle14c1B1B1BInterTight600
                            .copyWith(fontSize: 12.sp),
                      ),
                      if (reviewCount > 0) ...[
                        UIHelper.horizontalSpace(4.w),
                        Text(
                          "($reviewCount)",
                          style: TextFontStyle.textStyle14c1B1B1BInterTight600
                              .copyWith(
                            fontSize: 10.sp,
                            color: AppColors.c737373,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ],
                  ),
                  UIHelper.verticalSpace(8.h),
                  Row(
                    children: [
                      Assets.icons.locationOutlinedGrey.image(
                        width: 14.r,
                        height: 14.r,
                      ),
                      UIHelper.horizontalSpace(4.w),
                      Expanded(
                        child: Text(
                          "$distance • $address",
                          style: TextFontStyle.textStyle14c4D4D4DInterTight500
                              .copyWith(fontSize: 12.sp),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  UIHelper.verticalSpace(4.h),
                  Row(
                    children: [
                      Assets.icons.clockOutlinedGrey.image(
                        width: 14.r,
                        height: 14.r,
                      ),
                      UIHelper.horizontalSpace(4.w),
                      Expanded(
                        child: Text(
                          "$status • Ferme à $closingTime",
                          style: TextFontStyle.textStyle14c4D4D4DInterTight500
                              .copyWith(fontSize: 12.sp),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

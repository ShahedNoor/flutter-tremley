import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../gen/colors.gen.dart';
import '../../../../helpers/ui_helpers.dart';

class SalonReviewsSectionShimmer extends StatelessWidget {
  const SalonReviewsSectionShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: AppColors.cF6F6F6,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(height: 38.h, width: 60.w, color: Colors.white),
                UIHelper.horizontalSpace(12.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(height: 14.h, width: 80.w, color: Colors.white),
                    UIHelper.verticalSpace(4.h),
                    Container(height: 14.h, width: 100.w, color: Colors.white),
                  ],
                ),
              ],
            ),
            UIHelper.verticalSpace(20.h),
            const SalonReviewCardShimmer(),
            const SalonReviewCardShimmer(),
          ],
        ),
      ),
    );
  }
}

class SalonReviewCardShimmer extends StatelessWidget {
  const SalonReviewCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.cFFFFFF,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  height: 32.r,
                  width: 32.r,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
                UIHelper.horizontalSpace(10.w),
                Container(height: 16.h, width: 120.w, color: Colors.white),
              ],
            ),
            UIHelper.verticalSpace(12.h),
            Container(height: 14.h, width: double.infinity, color: Colors.white),
            UIHelper.verticalSpace(4.h),
            Container(height: 14.h, width: double.infinity, color: Colors.white),
            UIHelper.verticalSpace(4.h),
            Container(height: 14.h, width: 150.w, color: Colors.white),
          ],
        ),
      ),
    );
  }
}

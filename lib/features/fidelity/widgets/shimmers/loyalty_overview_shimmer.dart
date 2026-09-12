import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../gen/colors.gen.dart';
import '../../../../helpers/ui_helpers.dart';

class LoyaltyOverviewShimmer extends StatelessWidget {
  const LoyaltyOverviewShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        children: [
          UIHelper.verticalSpace(20.h),
          // Loyalty Card Shimmer
          Shimmer.fromColors(
            baseColor: AppColors.cE3E3E3,
            highlightColor: AppColors.cF2F2F2,
            child: Container(
              height: 180.h,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.cFFFFFF,
                borderRadius: BorderRadius.circular(16.r),
              ),
            ),
          ),
          UIHelper.verticalSpace(20.h),
          // Subtitle text shimmer
          Shimmer.fromColors(
            baseColor: AppColors.cE3E3E3,
            highlightColor: AppColors.cF2F2F2,
            child: Container(
              height: 16.h,
              width: 250.w,
              decoration: BoxDecoration(
                color: AppColors.cFFFFFF,
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
          ),
          UIHelper.verticalSpace(30.h),
          // First Button Shimmer
          Shimmer.fromColors(
            baseColor: AppColors.cE3E3E3,
            highlightColor: AppColors.cF2F2F2,
            child: Container(
              height: 56.h,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.cFFFFFF,
                borderRadius: BorderRadius.circular(16.r),
              ),
            ),
          ),
          UIHelper.verticalSpace(20.h),
          // Second Button Shimmer
          Shimmer.fromColors(
            baseColor: AppColors.cE3E3E3,
            highlightColor: AppColors.cF2F2F2,
            child: Container(
              height: 56.h,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.cFFFFFF,
                borderRadius: BorderRadius.circular(16.r),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

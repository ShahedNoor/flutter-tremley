import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../../gen/colors.gen.dart';
import '../../../../../helpers/ui_helpers.dart';

class ReservationShimmer extends StatelessWidget {
  const ReservationShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 5,
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.only(bottom: 16.h),
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: AppColors.cFFFFFF,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: AppColors.cF2F2F2),
          ),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(width: 150.w, height: 16.h, color: Colors.white),
                    Container(
                      width: 60.w,
                      height: 20.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                    ),
                  ],
                ),
                UIHelper.verticalSpace(8.h),
                Container(width: 100.w, height: 14.h, color: Colors.white),
                UIHelper.verticalSpace(12.h),
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Column(
                    children: [
                      Container(width: double.infinity, height: 14.h, color: Colors.white),
                      UIHelper.verticalSpace(8.h),
                      Container(width: double.infinity, height: 14.h, color: Colors.white),
                    ],
                  ),
                ),
                UIHelper.verticalSpace(12.h),
                Container(width: 120.w, height: 14.h, color: Colors.white),
              ],
            ),
          ),
        );
      },
    );
  }
}

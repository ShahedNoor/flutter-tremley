import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../../gen/colors.gen.dart';
import '../../../../../helpers/ui_helpers.dart';

class NotificationsShimmer extends StatelessWidget {
  const NotificationsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      itemCount: 10,
      separatorBuilder: (context, index) => UIHelper.verticalSpace(12.h),
      itemBuilder: (context, index) {
        return Container(
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: AppColors.cFFFFFF,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: AppColors.cF2F2F2, width: 1),
            boxShadow: [
              BoxShadow(
                color: AppColors.c000000.withValues(alpha: 0.02),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 48.r,
                  width: 48.r,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
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
                          Container(
                              width: 150.w, height: 16.h, color: Colors.white),
                          UIHelper.horizontalSpace(4.w),
                          Container(
                              width: 60.w, height: 12.h, color: Colors.white),
                        ],
                      ),
                      UIHelper.verticalSpace(8.h),
                      Container(
                          width: double.infinity,
                          height: 14.h,
                          color: Colors.white),
                      UIHelper.verticalSpace(4.h),
                      Container(
                          width: 200.w, height: 14.h, color: Colors.white),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

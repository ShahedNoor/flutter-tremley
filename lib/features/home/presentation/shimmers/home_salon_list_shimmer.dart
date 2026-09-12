import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../gen/colors.gen.dart';
import '../../../../helpers/ui_helpers.dart';

class HomeSalonListShimmer extends StatelessWidget {
  const HomeSalonListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10.w,
        mainAxisSpacing: 15.h,
        childAspectRatio: 0.75,
      ),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 4, // More items look better in grid shimmer
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.cFFFFFF,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: AppColors.cEEEEEE),
          ),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image Shimmer
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(16.r),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10.r),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Title Shimmer
                          Expanded(
                            child: Container(
                              height: 14.h,
                              color: Colors.white,
                            ),
                          ),
                          UIHelper.horizontalSpace(8.w),
                          // Rating Shimmer
                          Container(
                            height: 14.h,
                            width: 30.w,
                            color: Colors.white,
                          ),
                        ],
                      ),
                      UIHelper.verticalSpace(12.h),
                      // Address/Location Shimmer
                      Container(
                        height: 12.h,
                        width: double.infinity,
                        color: Colors.white,
                      ),
                      UIHelper.verticalSpace(8.h),
                      Container(
                        height: 12.h,
                        width: 80.w,
                        color: Colors.white,
                      ),
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

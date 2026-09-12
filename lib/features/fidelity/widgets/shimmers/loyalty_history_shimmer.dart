import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../gen/colors.gen.dart';
import '../../../../helpers/ui_helpers.dart';

class LoyaltyHistoryShimmer extends StatelessWidget {
  const LoyaltyHistoryShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        children: List.generate(6, (index) {
          return Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Shimmer.fromColors(
                          baseColor: AppColors.cE3E3E3,
                          highlightColor: AppColors.cF2F2F2,
                          child: Container(
                            height: 16.h,
                            width: 160.w,
                            decoration: BoxDecoration(
                              color: AppColors.cFFFFFF,
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                          ),
                        ),
                        UIHelper.verticalSpace(6.h),
                        Shimmer.fromColors(
                          baseColor: AppColors.cE3E3E3,
                          highlightColor: AppColors.cF2F2F2,
                          child: Container(
                            height: 14.h,
                            width: 110.w,
                            decoration: BoxDecoration(
                              color: AppColors.cFFFFFF,
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Shimmer.fromColors(
                    baseColor: AppColors.cE3E3E3,
                    highlightColor: AppColors.cF2F2F2,
                    child: Container(
                      height: 34.h,
                      width: 60.w,
                      decoration: BoxDecoration(
                        color: AppColors.cFFFFFF,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                  ),
                ],
              ),
              if (index < 5)
                Divider(
                  color: AppColors.cF2F2F2,
                  height: 32.h,
                ),
            ],
          );
        }),
      ),
    );
  }
}

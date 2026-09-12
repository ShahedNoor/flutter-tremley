import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../gen/colors.gen.dart';
import '../../../../helpers/ui_helpers.dart';

class ProfileShimmer extends StatelessWidget {
  const ProfileShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(UIHelper.kDefaulutPadding()),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Card Shimmer
            Container(
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: AppColors.cF2F2F2),
              ),
              child: Row(
                children: [
                  Container(
                    width: 60.r,
                    height: 60.r,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            width: 120.w, height: 20.h, color: Colors.white),
                        SizedBox(height: 8.h),
                        Container(
                            width: 180.w, height: 16.h, color: Colors.white),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            UIHelper.verticalSpace(30.h),

            // Profil & Paramètres Shimmer
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Column(
                children: [
                  _buildItemShimmer(),
                  Divider(
                      color: Colors.white,
                      height: 1,
                      indent: 16.w,
                      endIndent: 16.w),
                  _buildItemShimmer(),
                ],
              ),
            ),
            UIHelper.verticalSpace(16.h),

            // Other items
            _buildItemShimmer(isSingle: true),
            UIHelper.verticalSpace(16.h),
            _buildItemShimmer(isSingle: true),
            UIHelper.verticalSpace(16.h),
            _buildItemShimmer(isSingle: true),
            UIHelper.verticalSpace(30.h),

            // Suivez-nous Text Shimmer
            Container(width: 100.w, height: 18.h, color: Colors.white),
            UIHelper.verticalSpace(16.h),

            // Social Block Shimmer
            Container(
              padding: EdgeInsets.all(20.r),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildSocialItemShimmer(),
                      _buildSocialItemShimmer(),
                    ],
                  ),
                  UIHelper.verticalSpace(16.h),
                  Container(
                    height: 48.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                ],
              ),
            ),
            UIHelper.verticalSpace(30.h),

            // Logout Button Shimmer
            Container(
              height: 48.h,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            UIHelper.verticalSpace(30.h),
          ],
        ),
      ),
    );
  }

  Widget _buildItemShimmer({bool isSingle = false}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: isSingle ? BorderRadius.circular(12.r) : null,
      ),
      child: Row(
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(6.r),
            ),
          ),
          UIHelper.horizontalSpace(16.w),
          Expanded(
            child: Container(height: 16.h, color: Colors.grey[200]),
          ),
          UIHelper.horizontalSpace(16.w),
          Container(width: 14.w, height: 14.w, color: Colors.grey[200]),
        ],
      ),
    );
  }

  Widget _buildSocialItemShimmer() {
    return Column(
      children: [
        Container(
          width: 44.w,
          height: 44.w,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(6.r),
          ),
        ),
        UIHelper.verticalSpace(8.h),
        Container(width: 60.w, height: 14.h, color: Colors.grey[200]),
      ],
    );
  }
}

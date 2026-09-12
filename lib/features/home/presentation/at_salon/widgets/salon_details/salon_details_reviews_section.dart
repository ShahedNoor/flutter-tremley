import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tremley_cutomer/constants/text_font_style.dart';
import 'package:tremley_cutomer/gen/assets.gen.dart';
import 'package:tremley_cutomer/gen/colors.gen.dart';
import 'package:tremley_cutomer/helpers/ui_helpers.dart';

import 'package:tremley_cutomer/common_widgets/app_network_image.dart';
import '../../../shimmers/salon_reviews_shimmer.dart';

class SalonDetailsReviewsSection extends StatelessWidget {
  final double rating;
  final int reviewCount;
  final List reviews;
  final bool hasMore;
  final bool isLoadingMore;
  final VoidCallback? onLoadMore;

  const SalonDetailsReviewsSection({
    super.key,
    required this.rating,
    required this.reviewCount,
    required this.reviews,
    this.hasMore = false,
    this.isLoadingMore = false,
    this.onLoadMore,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: AppColors.cF6F6F6,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(rating.toString(),
                  style: TextFontStyle.textStyle32c191919InterTight700),
              UIHelper.horizontalSpace(12.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: List.generate(
                      5,
                      (index) => Padding(
                        padding: EdgeInsets.only(right: 2.w),
                        child: Assets.icons.starDeepGolden.image(
                          width: 14.r,
                          height: 14.r,
                          color: index < 4
                              ? AppColors.cC59A6D
                              : const Color(
                                  0xFFD3D3D3), // Fixing the red star from user's experiment
                        ),
                      ),
                    ),
                  ),
                  UIHelper.verticalSpace(4.h),
                  Text(
                    "Basé sur $reviewCount avis",
                    style:
                        TextFontStyle.textStyle14c4D4D4DInterTight500.copyWith(
                      fontSize: 12.sp,
                      color: const Color(0xFF8A8A8A),
                    ),
                  ),
                ],
              ),
            ],
          ),
          UIHelper.verticalSpace(20.h),
          if (reviews.isEmpty)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20.h),
              child: Center(
                child: Text(
                  "Aucun avis trouvé pour ce salon.",
                  style: TextFontStyle.textStyle14c4D4D4DInterTight500,
                  textAlign: TextAlign.center,
                ),
              ),
            )
          else
            ...reviews.map((review) => _buildReviewCard(review)),
          if (isLoadingMore) ...[
            UIHelper.verticalSpace(12.h),
            const SalonReviewCardShimmer(),
            const SalonReviewCardShimmer(),
          ] else if (hasMore) ...[
            UIHelper.verticalSpace(12.h),
            Center(
              child: GestureDetector(
                onTap: onLoadMore,
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Voir plus",
                        style: TextFontStyle.textStyle14c1B1B1BInterTight600
                            .copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      UIHelper.horizontalSpace(8.w),
                      const Icon(
                        Icons.arrow_forward_ios,
                        size: 14,
                        color: AppColors.c222222,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildReviewCard(Map<String, dynamic> review) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.cFFFFFF,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AppNetworkImage(
                imageUrl: review["profilePic"] ?? "",
                height: 32,
                width: 32,
                isProfilePicture: true,
              ),
              UIHelper.horizontalSpace(10.w),
              Text(
                review["name"],
                style: TextFontStyle.textStyle14c1B1B1BInterTight600.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          UIHelper.verticalSpace(12.h),
          Text(
            review["text"],
            style: TextFontStyle.textStyle14c4D4D4DInterTight500.copyWith(
              fontSize: 14.sp,
              color: const Color(0xFF4D4D4D),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

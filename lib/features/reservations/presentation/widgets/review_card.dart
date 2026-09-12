import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../gen/colors.gen.dart';
import '../../../../constants/text_font_style.dart';
import 'rating_stars.dart';

class ReviewCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String badgeText;
  final Widget? leading;
  final int currentRating;
  final Function(int)? onRatingChanged;
  final bool isRated;
  final String? feedbackText;
  final TextEditingController? commentController;

  const ReviewCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.badgeText,
    this.leading,
    required this.currentRating,
    this.onRatingChanged,
    this.isRated = false,
    this.feedbackText,
    this.commentController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.cF2F2F2),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (leading != null) ...[
                leading!,
                SizedBox(width: 12.w),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextFontStyle.textStyle16c191919Inter600.copyWith(
                        fontSize: 15.sp,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextFontStyle.textStyle13c8A8A8AInter400,
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColors.cFBF4E0,
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Text(
                  badgeText,
                  style: TextFontStyle.textStyle12cB08D2AInterTight500.copyWith(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          RatingStars(
            rating: currentRating,
            onRatingChanged: isRated ? null : onRatingChanged,
            starSize: 28,
          ),
          if (isRated && feedbackText != null) ...[
            SizedBox(height: 16.h),
            Text(
              feedbackText!,
              style: TextFontStyle.textStyle14c191919Inter500.copyWith(
                color: AppColors.c4D4D4D,
                height: 1.4,
              ),
            ),
          ],
          if (!isRated && commentController != null) ...[
            SizedBox(height: 16.h),
            TextField(
              controller: commentController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: "Laissez un commentaire...",
                hintStyle: TextFontStyle.textStyle14c8A8A8AInter400.copyWith(
                  fontSize: 13.sp,
                ),
                contentPadding: EdgeInsets.all(16.r),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: const BorderSide(color: AppColors.cE3E3E3),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: const BorderSide(color: AppColors.cE3E3E3),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

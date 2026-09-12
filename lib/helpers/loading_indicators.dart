import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import '../gen/colors.gen.dart';

Widget loadingIndicatorCircle({
  required BuildContext context,
  Color? color,
  double? size,
}) {
  return Center(
    child: SizedBox(
      height: size ?? 40.sp,
      width: size ?? 40.sp,
      child: CircularProgressIndicator(
        color: color ?? AppColors.cFFFFFF,
        strokeWidth: 3,
      ),
    ),
  );
}

Widget skeletonShimmer({
  required double width,
  required double height,
  double borderRadius = 8,
}) {
  return Shimmer.fromColors(
    baseColor: AppColors.cF0F0F0,
    highlightColor: AppColors.cFFFFFF,
    child: Container(
      width: width.w,
      height: height.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(borderRadius.r),
      ),
    ),
  );
}

Widget shimmer({
  required BuildContext context,
  String? name,
  double? size,
}) {
  // If the name suggests a "not found" state, show an icon and text
  if (name != null && name.contains('not_found')) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: size ?? 80.sp,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16.h),
          Text(
            "Aucun résultat trouvé",
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // Default to a simple shimmer effect
  return Shimmer.fromColors(
    baseColor: AppColors.cF0F0F0,
    highlightColor: AppColors.cFFFFFF,
    child: Container(
      width: size ?? 40.sp,
      height: size ?? 40.sp,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
    ),
  );
}

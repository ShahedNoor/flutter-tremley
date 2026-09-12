import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../gen/colors.gen.dart';
import '../helpers/navigation_service.dart';
import '../helpers/ui_helpers.dart';

void customToastMessage(String title, String description) {
  // Get the root scaffold messenger
  final context = NavigationService.navigatorKey.currentContext!;

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.sp,
              color: AppColors.cFFFFFF,
            ),
          ),
          UIHelper.verticalSpace(4),
          Text(
            description,
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.cFFFFFF,
            ),
          ),
        ],
      ),
      backgroundColor: AppColors.c191919,
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.all(16.sp),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.r),
      ),
      duration: const Duration(seconds: 3),
      // No action button - will auto close after 3 seconds
    ),
  );
}

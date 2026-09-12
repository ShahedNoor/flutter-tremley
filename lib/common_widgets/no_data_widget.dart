// lib/common_widgets/no_data_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '/constants/text_font_style.dart';
import '/gen/colors.gen.dart';
import '/helpers/ui_helpers.dart';
import 'custom_button.dart';

class NoDataWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? imagePath;
  final IconData? icon;
  final double iconSize;
  final Color iconColor;
  final bool showActionButton;
  final String actionText;
  final VoidCallback? onActionPressed;
  final double verticalPadding;

  const NoDataWidget({
    super.key,
    required this.title,
    required this.subtitle,
    this.imagePath,
    this.icon,
    this.iconSize = 80,
    this.iconColor = AppColors.c9B9B9B,
    this.showActionButton = false,
    this.actionText = 'Try Again',
    this.onActionPressed,
    this.verticalPadding = 100,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: 40.w, vertical: verticalPadding.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Image or Icon
          if (imagePath != null)
            Image.asset(
              imagePath!,
              height: 120.h,
              width: 120.w,
              fit: BoxFit.contain,
            )
          else if (icon != null)
            Icon(
              icon,
              size: iconSize.sp,
              color: iconColor,
            )
          else
            Icon(
              Icons.inbox_outlined,
              size: iconSize.sp,
              color: iconColor,
            ),

          UIHelper.verticalSpace(24.h),

          // Title
          Text(
            title,
            style: TextFontStyle.textStyle18c191919Inter700,
            textAlign: TextAlign.center,
          ),

          UIHelper.verticalSpace(8.h),

          // Subtitle
          Text(
            subtitle,
            style: TextFontStyle.textStyle14c6C6C6CInterTight500.copyWith(
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),

          UIHelper.verticalSpace(24.h),

          // Action Button (Optional)
          if (showActionButton)
            CustomButton(
              onPressed: onActionPressed,
              title: actionText,
              width: 150.w,
              height: 45.h,
              backgroundColor: AppColors.allPrimaryColor,
              borderRadius: BorderRadius.circular(8.r),
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
        ],
      ),
    );
  }
}

// Specific NoDataWidget variations for common use cases
class NoProductsWidget extends StatelessWidget {
  final VoidCallback? onRefresh;

  const NoProductsWidget({super.key, this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return NoDataWidget(
      title: 'No Products Found',
      subtitle:
          'We couldn\'t find any products matching your criteria. Please try again later.',
      icon: Icons.shopping_bag_outlined,
      showActionButton: onRefresh != null,
      actionText: 'Refresh',
      onActionPressed: onRefresh,
    );
  }
}

class NoInternetWidget extends StatelessWidget {
  final VoidCallback? onRetry;

  const NoInternetWidget({super.key, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return NoDataWidget(
      title: 'No Internet Connection',
      subtitle: 'Please check your internet connection and try again.',
      icon: Icons.wifi_off_outlined,
      showActionButton: true,
      actionText: 'Retry',
      onActionPressed: onRetry,
    );
  }
}

class NoFavoritesWidget extends StatelessWidget {
  final VoidCallback? onBrowse;

  const NoFavoritesWidget({super.key, this.onBrowse});

  @override
  Widget build(BuildContext context) {
    return NoDataWidget(
      title: 'No Favorites Yet',
      subtitle:
          'Start browsing products and add your favorites to see them here.',
      icon: Icons.favorite_border,
      showActionButton: onBrowse != null,
      actionText: 'Browse Products',
      onActionPressed: onBrowse,
    );
  }
}

// lib/common_widgets/generic_cached_image.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double? height;
  final double? width;
  final BoxFit fit;
  final BorderRadiusGeometry? borderRadius;
  final Color placeholderColor;
  final Color errorColor;
  final Widget? customPlaceholder;
  final Widget? customErrorWidget;
  final double placeholderIconSize;
  final double errorIconSize;
  final bool isProfilePicture;

  const AppNetworkImage({
    super.key,
    required this.imageUrl,
    this.height,
    this.width,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.placeholderColor = const Color(0xFFF5F5F5),
    this.errorColor = const Color(0xFFE8E8E8),
    this.customPlaceholder,
    this.customErrorWidget,
    this.placeholderIconSize = 24,
    this.errorIconSize = 32,
    this.isProfilePicture = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isProfilePicture) {
      return CachedNetworkImage(
        imageUrl: imageUrl,
        height: height?.h,
        width: width?.w,
        fit: fit,
        fadeInDuration: const Duration(milliseconds: 300),
        fadeOutDuration: const Duration(milliseconds: 300),
        imageBuilder: (context, imageProvider) => Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: imageProvider,
              fit: fit,
            ),
          ),
        ),
        placeholder: (context, url) =>
            customPlaceholder ?? _buildPlaceholder(isCircle: true),
        errorWidget: (context, url, error) =>
            customErrorWidget ?? _buildErrorWidget(isCircle: true),
      );
    }

    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        height: height?.h,
        width: width?.w,
        fit: fit,
        fadeInDuration: const Duration(milliseconds: 300),
        fadeOutDuration: const Duration(milliseconds: 300),
        placeholder: (context, url) => customPlaceholder ?? _buildPlaceholder(),
        errorWidget: (context, url, error) =>
            customErrorWidget ?? _buildErrorWidget(),
      ),
    );
  }

  Widget _buildPlaceholder({bool isCircle = false}) {
    return Container(
      height: height?.h,
      width: width?.w,
      decoration: BoxDecoration(
        color: placeholderColor,
        shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
      ),
      child: Center(
        child: SizedBox(
          width: placeholderIconSize.w,
          height: placeholderIconSize.h,
          child: CircularProgressIndicator(
            strokeWidth: 2.w,
            valueColor: AlwaysStoppedAnimation<Color>(
              isProfilePicture ? const Color(0xFFB08D2A) : Colors.grey[600]!,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorWidget({bool isCircle = false}) {
    return Container(
      height: height?.h,
      width: width?.w,
      decoration: BoxDecoration(
        color: isProfilePicture ? const Color(0xFFF9F1DC) : errorColor,
        shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
      ),
      child: Center(
        child: Icon(
          isProfilePicture ? Icons.person : Icons.image_not_supported_outlined,
          size: errorIconSize.sp,
          color: isProfilePicture ? const Color(0xFFB08D2A) : Colors.grey[500],
        ),
      ),
    );
  }
}

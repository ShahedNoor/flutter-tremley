// lib/widgets/buttons/custom_button.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../helpers/ui_helpers.dart';
import '/constants/text_font_style.dart';
import '/gen/colors.gen.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.onPressed,
    required this.title,
    this.isLoading = false,
    this.backgroundColor = AppColors.c000000,
    this.foregroundColor = AppColors.cFFFFFF,
    this.borderRadius,
    this.height,
    this.width,
    this.textStyle,
    this.padding,
    this.fontSize,
    this.fontWeight,
    this.borderColor,
    this.borderWidth,
    this.elevation = 0,
    this.icon,
  });

  final VoidCallback? onPressed;
  final String title;
  final bool isLoading;
  final Color backgroundColor;
  final Color foregroundColor;
  final BorderRadiusGeometry? borderRadius;
  final double? height;
  final double? width;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry? padding;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? borderColor;
  final double? borderWidth;
  final double elevation;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? 50.h,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          disabledBackgroundColor: backgroundColor.withValues(alpha: 0.5),
          disabledForegroundColor: foregroundColor.withValues(alpha: 0.5),
          elevation: elevation,
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(12.r),
            side: borderColor != null
                ? BorderSide(
                    color: borderColor!,
                    width: borderWidth ?? 1.w,
                  )
                : BorderSide.none,
          ),
          padding: padding ?? EdgeInsets.symmetric(horizontal: 16.w),
        ),
        child: isLoading
            ? SizedBox(
                width: 20.w,
                height: 20.h,
                child: CircularProgressIndicator(
                  strokeWidth: 2.w,
                  valueColor: AlwaysStoppedAnimation<Color>(foregroundColor),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    icon!,
                    UIHelper.horizontalSpace(8.w),
                  ],
                  Text(
                    title,
                    style: textStyle ??
                        TextFontStyle.textStyle16cFFFFFFInterTight700.copyWith(
                          color: foregroundColor,
                          fontSize: fontSize ?? 16.sp,
                          fontWeight: fontWeight ?? FontWeight.w700,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
      ),
    );
  }
}

// Alternative function-style customButton (calls the Class for consistency)
Widget customButton({
  required VoidCallback? onPressed,
  required String title,
  bool isLoading = false,
  Color backgroundColor = AppColors.c000000,
  Color foregroundColor = AppColors.cFFFFFF,
  BorderRadiusGeometry? borderRadius,
  double? height,
  double? width,
  TextStyle? textStyle,
  EdgeInsetsGeometry? padding,
  double? fontSize,
  FontWeight? fontWeight,
  Color? borderColor,
  double? borderWidth,
  double elevation = 0,
  Widget? icon,
}) {
  return CustomButton(
    onPressed: onPressed,
    title: title,
    isLoading: isLoading,
    backgroundColor: backgroundColor,
    foregroundColor: foregroundColor,
    borderRadius: borderRadius,
    height: height,
    width: width,
    textStyle: textStyle,
    padding: padding,
    fontSize: fontSize,
    fontWeight: fontWeight,
    borderColor: borderColor,
    borderWidth: borderWidth,
    elevation: elevation,
    icon: icon,
  );
}


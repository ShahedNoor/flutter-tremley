// lib/common_widgets/custom_appbar.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tremley_cutomer/helpers/navigation_service.dart';
import '/constants/text_font_style.dart';
import '/gen/colors.gen.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? title;
  final String? titleText;
  final bool showBackArrow;
  final VoidCallback? onBackPressed;
  final List<Widget>? actions;
  final bool isSuffix;
  final bool centerTitle;
  final Color? backgroundColor;
  final double? elevation;
  final Widget? leading;

  const CustomAppBar({
    super.key,
    this.title,
    this.titleText,
    this.showBackArrow = false,
    this.onBackPressed,
    this.actions,
    this.isSuffix = false,
    this.centerTitle = false,
    this.backgroundColor,
    this.elevation,
    this.leading,
  });

  @override
  Size get preferredSize => Size.fromHeight(56.h);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor ?? AppColors.cFFFFFF,
      elevation: elevation ?? 0,
      centerTitle: centerTitle,
      automaticallyImplyLeading: false,
      leading: showBackArrow
          ? (leading ??
              IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  size: 20.sp,
                  color: AppColors.c191919,
                ),
                onPressed:
                    onBackPressed ?? () => NavigationService.goBackCall(),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ))
          : null,
      title: title ??
          (titleText != null
              ? Text(
                  titleText!,
                  style: TextFontStyle.textStyle18c191919Inter700,
                )
              : null),
      actions: actions ?? (isSuffix ? [_buildSuffixButton()] : null),
    );
  }

  Widget _buildSuffixButton() {
    return Padding(
      padding: EdgeInsets.only(right: 16.w),
      child: Icon(
        Icons.more_vert,
        size: 24.sp,
        color: AppColors.c191919,
      ),
    );
  }
}

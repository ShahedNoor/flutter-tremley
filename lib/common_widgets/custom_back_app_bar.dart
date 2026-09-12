import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tremley_cutomer/helpers/navigation_service.dart';
import '../constants/text_font_style.dart';
import '../gen/assets.gen.dart';
import '../gen/colors.gen.dart';

class CustomBackAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBack;
  final List<Widget>? actions;

  const CustomBackAppBar({
    super.key,
    required this.title,
    this.onBack,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.cFFFFFF,
      elevation: 0,
      centerTitle: true,
      leading: Padding(
        padding: EdgeInsets.only(left: 20.w),
        child: IconButton(
          onPressed: onBack ?? () => NavigationService.goBackCall(),
          padding:
              EdgeInsets.zero, // Remove default padding for precise alignment
          icon: Assets.icons.arrowBackBlack.image(
            width: 24.r,
            height: 24.r,
            fit: BoxFit.contain,
          ),
        ),
      ),
      title: Text(title, style: TextFontStyle.textStyle24c000000InterTight700),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight.h);
}

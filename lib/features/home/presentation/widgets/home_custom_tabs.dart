import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../constants/text_font_style.dart';
import '../../../../../gen/colors.gen.dart';
import '../../../../../helpers/ui_helpers.dart';

class HomeCustomTabs extends StatelessWidget {
  final int selectedTab;
  final ValueChanged<int> onTabChanged;

  const HomeCustomTabs({
    super.key,
    required this.selectedTab,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => onTabChanged(0),
              behavior: HitTestBehavior.opaque,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "RDV au salon",
                    style: TextFontStyle.textStyle18c1B1B1BInterTight700
                  ),
                  UIHelper.verticalSpace(8.h),
                  Container(
                    height: 2.h,
                    color: selectedTab == 0 ? AppColors.c191919 : AppColors.cE3E3E3,
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => onTabChanged(1),
              behavior: HitTestBehavior.opaque,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "À domicile",
                    style: TextFontStyle.textStyle18c1B1B1BInterTight700.copyWith(
                      color: selectedTab == 1 ? AppColors.c191919 : AppColors.c8A8A8A,
                    ),
                  ),
                  UIHelper.verticalSpace(8.h),
                  Container(
                    height: 2.h,
                    color: selectedTab == 1 ? AppColors.c191919 : AppColors.cE3E3E3,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

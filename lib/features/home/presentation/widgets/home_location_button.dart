import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../constants/text_font_style.dart';
import '../../../../../gen/assets.gen.dart';
import '../../../../../helpers/ui_helpers.dart';

class HomeLocationButton extends StatelessWidget {
  const HomeLocationButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 14.h),
        decoration: BoxDecoration(
          color: const Color(0xFFE5E5E5),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Assets.icons.locationGrey.image(
              width: 20.r,
              height: 20.r,
            ),
            UIHelper.horizontalSpace(8.w),
            Text(
              "Utiliser ma position",
              style: TextFontStyle.textStyle16c1B1B1BInterTight600.copyWith(
                color: const Color(0xFF6B6B6B),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

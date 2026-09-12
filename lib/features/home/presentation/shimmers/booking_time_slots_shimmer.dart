import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tremley_cutomer/constants/text_font_style.dart';
import 'package:tremley_cutomer/helpers/ui_helpers.dart';

class BookingTimeSlotsShimmer extends StatelessWidget {
  const BookingTimeSlotsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Heure disponible",
          style: TextFontStyle.textStyle20c191919Inter600,
        ),
        UIHelper.verticalSpace(16.h),
        LayoutBuilder(builder: (context, constraints) {
          double width = (constraints.maxWidth - 24.w) / 3;

          return Wrap(
            spacing: 12.w,
            runSpacing: 12.h,
            children: List.generate(9, (index) {
              return Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  width: width,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Center(
                    child: Container(
                      width: 60.w,
                      height: 12.h,
                      color: Colors.white,
                    ),
                  ),
                ),
              );
            }),
          );
        }),
      ],
    );
  }
}

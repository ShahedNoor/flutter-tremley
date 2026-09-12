import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tremley_cutomer/common_widgets/app_network_image.dart';
import 'package:tremley_cutomer/constants/text_font_style.dart';
import 'package:tremley_cutomer/gen/assets.gen.dart';
import 'package:tremley_cutomer/gen/colors.gen.dart';
import 'package:tremley_cutomer/helpers/ui_helpers.dart';

class PaymentBarberCard extends StatelessWidget {
  final String barberName;
  final String barberImage;
  final double barberRating;

  const PaymentBarberCard({
    super.key,
    required this.barberName,
    required this.barberImage,
    required this.barberRating,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.cFFFFFF,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.cEEEEEE, width: 1),
      ),
      child: Row(
        children: [
          AppNetworkImage(
            width: 50.r,
            height: 50.r,
            imageUrl: barberImage,
            isProfilePicture: true,
          ),
          UIHelper.horizontalSpace(12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Votre barbier",
                    style: TextFontStyle.textStyle12c9B9B9BInter400),
                UIHelper.verticalSpace(2.h),
                Text(barberName,
                    style: TextFontStyle.textStyle18c222222Inter500),
              ],
            ),
          ),
          Row(
            children: [
              Assets.icons.starDeepGolden.image(width: 14.r, height: 14.r),
              UIHelper.horizontalSpace(4.w),
              Text(barberRating.toString(),
                  style: TextFontStyle.textStyle13c222222Inter500),
            ],
          ),
        ],
      ),
    );
  }
}

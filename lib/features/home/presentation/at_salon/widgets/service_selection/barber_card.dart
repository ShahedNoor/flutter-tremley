import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../common_widgets/app_network_image.dart';
import '../../../../../../constants/text_font_style.dart';
import '../../../../../../gen/assets.gen.dart';
import '../../../../../../gen/colors.gen.dart';
import '../../../../../../helpers/ui_helpers.dart';
import '../../../../model/barber_list_model.dart';

class BarberCard extends StatelessWidget {
  final Barber barber;
  final bool isSelected;
  final VoidCallback onTap;

  const BarberCard({
    super.key,
    required this.barber,
    this.isSelected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: AppColors.cFFFFFF,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isSelected ? AppColors.cB08D2A : AppColors.cEEEEEE,
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            AppNetworkImage(
              width: 50.r,
              height: 50.r,
              imageUrl: barber.profileImage ?? "",
              isProfilePicture: true,
            ),
            UIHelper.horizontalSpace(12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Votre barbier",
                    style: TextFontStyle.textStyle14c8A8A8AInter400.copyWith(
                      fontSize: 13.sp,
                      color: AppColors.c8A8A8A,
                    ),
                  ),
                  Text(
                    barber.name ?? "Unknown",
                    style: TextFontStyle.textStyle16c191919Inter600.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.c191919,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Assets.icons.reviewStarGolden.image(width: 16.r, height: 16.r),
                UIHelper.horizontalSpace(4.w),
                // Dynamically show rating or 0 if null
                Text(barber.averageRating?.toString() ?? "0", style: TextFontStyle.textStyle13c222222Inter500),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

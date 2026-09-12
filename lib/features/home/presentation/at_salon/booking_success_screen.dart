import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tremley_cutomer/common_widgets/custom_button.dart';
import 'package:tremley_cutomer/constants/text_font_style.dart';
import 'package:tremley_cutomer/gen/assets.gen.dart';
import 'package:tremley_cutomer/gen/colors.gen.dart';
import 'package:tremley_cutomer/helpers/navigation_service.dart';
import 'package:tremley_cutomer/helpers/ui_helpers.dart';

import '../../../../helpers/all_routes.dart';

class BookingSuccessScreen extends StatelessWidget {
  final String salonName;
  final String serviceName;
  final String duration;
  final String dateTime;

  const BookingSuccessScreen({
    super.key,
    required this.salonName,
    required this.serviceName,
    required this.duration,
    required this.dateTime,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cFFFFFF,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            children: [
              const Spacer(flex: 2),
              // Success Icon
              Center(
                child: Container(
                  width: 100.r,
                  height: 100.r,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE8F5EE), // Light green background
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.check_rounded,
                      color: const Color(0xFF23A26D), // Success green
                      size: 50.r,
                    ),
                  ),
                ),
              ),
              UIHelper.verticalSpace(32.h),
              // Confirmation Title
              Text(
                "Votre réservation est\nconfirmée",
                textAlign: TextAlign.center,
                style: TextFontStyle.textStyle24c1B1B1BInterTight700.copyWith(
                  height: 1.2,
                ),
              ),
              UIHelper.verticalSpace(32.h),
              // Summary Card (Simplified for Success Page)
              _buildSuccessSummaryCard(),
              const Spacer(flex: 3),
              // Action Buttons
              CustomButton(
                onPressed: () {
                  NavigationService.navigateToUntilReplacementWithArgs(
                    Routes.navigationScreen,
                    {'initialIndex': 1},
                  );
                },
                title: "Voir mes réservations",
                backgroundColor: AppColors.cEEEEEE,
                foregroundColor: AppColors.c191919,
                height: 56.h,
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
              ),
              UIHelper.verticalSpace(12.h),
              CustomButton(
                onPressed: () {
                  NavigationService.navigateToUntilReplacement(
                      Routes.navigationScreen);
                },
                title: "Retour à l'accueil",
                backgroundColor: AppColors.c222222,
                height: 56.h,
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
              ),
              UIHelper.verticalSpace(24.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessSummaryCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: AppColors.cFFFFFF,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.cEEEEEE),
      ),
      child: Column(
        children: [
          _SummaryItem(
            iconAsset: Assets.icons.storeOutlinedGolden,
            text: salonName,
          ),
          UIHelper.verticalSpace(16.h),
          _SummaryItem(
            iconAsset: Assets.icons.scissorsOutlinedGolden,
            text: "$serviceName ($duration)",
          ),
          UIHelper.verticalSpace(16.h),
          _SummaryItem(
            iconAsset: Assets.icons.calendarOutlinedGolden,
            text: dateTime,
          ),
        ],
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final AssetGenImage iconAsset;
  final String text;

  const _SummaryItem({required this.iconAsset, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 36.r,
          height: 36.r,
          decoration: BoxDecoration(
            color: AppColors.cFFFFFF,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: AppColors.cEEEEEE),
          ),
          child: Center(
            child: iconAsset.image(width: 18.r, height: 18.r),
          ),
        ),
        UIHelper.horizontalSpace(12.w),
        Expanded(
          child: Text(
            text,
            style: TextFontStyle.textStyle16c1B1B1BInterTight500,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

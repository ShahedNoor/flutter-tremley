import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tremley_cutomer/constants/text_font_style.dart';
import 'package:tremley_cutomer/gen/assets.gen.dart';
import 'package:tremley_cutomer/gen/colors.gen.dart';
import 'package:tremley_cutomer/helpers/ui_helpers.dart';

class PaymentMethodSelector extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onChanged;

  const PaymentMethodSelector({
    super.key,
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildPaymentOption(
          0,
          "Payer en ligne",
          "Carte bancaire ou Apple Pay",
          Assets.icons.payOnlineBlack,
        ),
        UIHelper.verticalSpace(16.h),
        _buildPaymentOption(
          1,
          "Payer sur place",
          "Payez directement au salon",
          Assets.icons.payOnsiteBlack,
        ),
      ],
    );
  }

  Widget _buildPaymentOption(
      int index, String title, String subTitle, AssetGenImage icon) {
    bool isSelected = index == selectedIndex;
    return GestureDetector(
      onTap: () => onChanged(index),
      child: Container(
        padding: EdgeInsets.all(20.r),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.cF6F6F6 : AppColors.cFFFFFF,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isSelected ? AppColors.cB08D2A : AppColors.cEEEEEE,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            // Radio button
            Container(
              height: 24.r,
              width: 24.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color:
                      isSelected ? AppColors.cB08D2A : const Color(0xFFE0E0E0),
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        height: 12.r,
                        width: 12.r,
                        decoration: const BoxDecoration(
                          color: AppColors.cB08D2A,
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  : null,
            ),
            UIHelper.horizontalSpace(16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextFontStyle.textStyle18c1B1B1BInterTight600,
                  ),
                  UIHelper.verticalSpace(4.h),
                  Text(
                    subTitle,
                    style: TextFontStyle.textStyle14c6C6C6CInterTight500,
                  )
                ],
              ),
            ),
            icon.image(
              width: 28.r,
              height: 28.r,
            ),
          ],
        ),
      ),
    );
  }
}

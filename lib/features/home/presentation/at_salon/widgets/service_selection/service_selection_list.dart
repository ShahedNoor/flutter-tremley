import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tremley_cutomer/constants/text_font_style.dart';
import 'package:tremley_cutomer/gen/colors.gen.dart';
import 'package:tremley_cutomer/helpers/ui_helpers.dart';

import '../../../../model/service_list_model.dart';

class ServiceSelectionList extends StatelessWidget {
  final List<ServiceItem> services;
  final int selectedIndex;
  final Function(int) onServiceSelected;

  const ServiceSelectionList({
    super.key,
    required this.services,
    required this.selectedIndex,
    required this.onServiceSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        services.length,
        (index) {
          final service = services[index];
          final price = service.servicePrice?.price ?? '0';
          final discount = service.servicePrice?.discount;
          final double priceVal = double.tryParse(price) ?? 0;
          final double discountVal = double.tryParse(discount ?? '0') ?? 0;
          final double finalPrice = priceVal - discountVal;

          return Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: _ServiceSelectionCard(
              title: service.serviceName ?? '',
              duration: "${service.servicePrice?.timeDuration ?? '0'} min",
              price:
                  "${finalPrice % 1 == 0 ? finalPrice.toInt() : finalPrice.toStringAsFixed(2)} €",
              isSelected: index == selectedIndex,
              onTap: () => onServiceSelected(index),
            ),
          );
        },
      ),
    );
  }
}

class _ServiceSelectionCard extends StatelessWidget {
  final String title;
  final String duration;
  final String price;
  final bool isSelected;
  final VoidCallback onTap;

  const _ServiceSelectionCard({
    required this.title,
    required this.duration,
    required this.price,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        constraints: BoxConstraints(minHeight: 100.h),
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: AppColors.cFFFFFF,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isSelected ? AppColors.cB08D2A : AppColors.cEEEEEE,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style:
                        TextFontStyle.textStyle18c1B1B1BInterTight700.copyWith(
                      fontSize: 18.sp,
                    ),
                  ),
                  UIHelper.verticalSpace(6.h),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 16.r,
                        color: const Color(0xFF8A8A8A),
                      ),
                      UIHelper.horizontalSpace(6.w),
                      Text(
                        duration,
                        style: TextFontStyle.textStyle14c8A8A8AInter400,
                      ),
                    ],
                  ),
                  UIHelper.verticalSpace(8.h),
                  Text(
                    price,
                    style: TextFontStyle.textStyle16c191919Inter600.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 18.sp,
                    ),
                  ),
                ],
              ),
            ),
            // Custom Radio Button
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
          ],
        ),
      ),
    );
  }
}

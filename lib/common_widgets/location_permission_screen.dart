import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/text_font_style.dart';
import '../gen/colors.gen.dart';
import '../helpers/ui_helpers.dart';
import 'address_search_bottom_sheet.dart';
import 'custom_button.dart';

class LocationPermissionScreen extends StatelessWidget {
  final String? title;
  final String? message;
  final String gpsButtonTitle;
  final VoidCallback onGpsPressed;
  final VoidCallback? onLocationSelected;
  final bool isLoading;

  const LocationPermissionScreen({
    super.key,
    this.title,
    this.message,
    required this.gpsButtonTitle,
    required this.onGpsPressed,
    this.onLocationSelected,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Branded Icon badge
            Container(
              width: 100.r,
              height: 100.r,
              decoration: BoxDecoration(
                color: AppColors.allPrimaryColor.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Container(
                  width: 72.r,
                  height: 72.r,
                  decoration: BoxDecoration(
                    color: AppColors.allPrimaryColor.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.location_on_rounded,
                      size: 40.sp,
                      color: AppColors.allPrimaryColor,
                    ),
                  ),
                ),
              ),
            ),
            UIHelper.verticalSpace(24.h),

            // Title
            Text(
              title ?? "Trouvez les salons près de vous",
              textAlign: TextAlign.center,
              style: TextFontStyle.textStyle20c191919Inter600.copyWith(
                fontSize: 22.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            UIHelper.verticalSpace(12.h),

            // Message / explanation
            Text(
              message ??
                  "Pour afficher les barbiers et salons disponibles autour de vous, choisissez votre ville ou activez la géolocalisation.",
              textAlign: TextAlign.center,
              style: TextFontStyle.textStyle14c737373Inter400.copyWith(
                height: 1.5,
              ),
            ),
            UIHelper.verticalSpace(28.h),

            // Benefit cards
            _buildBenefitItem(
              icon: Icons.storefront_outlined,
              title: "Barbiers & salons à proximité",
              subtitle: "Consultez les établissements les plus proches",
            ),
            UIHelper.verticalSpace(10.h),
            _buildBenefitItem(
              icon: Icons.schedule_rounded,
              title: "Réservation rapide",
              subtitle: "Réservez en salon ou demandez à domicile",
            ),
            UIHelper.verticalSpace(32.h),

            // Primary Button: Enter address manually
            CustomButton(
              width: 1.sw,
              backgroundColor: AppColors.allPrimaryColor,
              onPressed: () {
                AddressSearchBottomSheet.show(
                  context,
                  onLocationSelected: (lat, lng, address) {
                    onLocationSelected?.call();
                  },
                );
              },
              title: "Saisir une adresse / ville",
            ),
            UIHelper.verticalSpace(12.h),

            // Secondary Outlined Button: Enable GPS / Open settings
            SizedBox(
              width: 1.sw,
              height: 52.h,
              child: OutlinedButton(
                onPressed: onGpsPressed,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(
                    color: AppColors.allPrimaryColor,
                    width: 1.5,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  backgroundColor: Colors.transparent,
                ),
                child: isLoading
                    ? SizedBox(
                        width: 20.r,
                        height: 20.r,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.allPrimaryColor,
                          ),
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.my_location_rounded,
                            size: 18.sp,
                            color: AppColors.allPrimaryColor,
                          ),
                          UIHelper.horizontalSpace(8.w),
                          Text(
                            gpsButtonTitle,
                            style: TextFontStyle.textStyle16c191919Inter600
                                .copyWith(
                              color: AppColors.allPrimaryColor,
                              fontSize: 15.sp,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBenefitItem({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: AppColors.cF4F4F4,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.r),
            decoration: const BoxDecoration(
              color: AppColors.cFFFFFF,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 18.sp,
              color: AppColors.allPrimaryColor,
            ),
          ),
          UIHelper.horizontalSpace(12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextFontStyle.textStyle14c191919Inter600.copyWith(
                    fontSize: 13.sp,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextFontStyle.textStyle12c737373Inter400,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

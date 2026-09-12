import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tremley_cutomer/common_widgets/custom_button.dart';
import 'package:tremley_cutomer/constants/text_font_style.dart';
import 'package:tremley_cutomer/gen/assets.gen.dart';
import 'package:tremley_cutomer/gen/colors.gen.dart';
import 'package:tremley_cutomer/helpers/ui_helpers.dart';
import 'package:tremley_cutomer/helpers/navigation_service.dart';
import 'package:tremley_cutomer/helpers/all_routes.dart';
import 'package:intl/intl.dart';

class BookingSuccessScreen extends StatelessWidget {
  final Map<String, dynamic>? apiResponse;
  final bool isPaymentCompleted;

  const BookingSuccessScreen(
      {super.key, this.apiResponse, this.isPaymentCompleted = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cFFFFFF,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              const Spacer(),

              // Success Mark
              _buildSuccessIcon(),

              UIHelper.verticalSpace(40.h),

              // Success Title
              Text(
                  isPaymentCompleted
                      ? "Paiement réussi !"
                      : "Demande envoyée au barbier !",
                  textAlign: TextAlign.center,
                  style: TextFontStyle.textStyle24c1B1B1BInterTight700),

              UIHelper.verticalSpace(32.h),

              // Booking Detail Card
              _buildDetailCard(),

              const Spacer(),

              // Action Buttons
              CustomButton(
                onPressed: () {
                  NavigationService.navigateToUntilReplacementWithArgs(
                    Routes.navigationScreen,
                    {'initialIndex': 1},
                  );
                },
                title: "Voir mes réservations",
                height: 56.h,
                backgroundColor: const Color(0xFFE0E0E0),
                foregroundColor: AppColors.c191919,
              ),

              UIHelper.verticalSpace(16.h),

              CustomButton(
                onPressed: () {
                  NavigationService.navigateToUntilReplacement(
                      Routes.navigationScreen);
                },
                title: "Retour à l'accueil",
                height: 56.h,
                backgroundColor: AppColors.c191919,
                foregroundColor: AppColors.cFFFFFF,
              ),

              UIHelper.verticalSpace(20.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessIcon() {
    return Container(
      width: 100.r,
      height: 100.r,
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Container(
          width: 56.r,
          height: 56.r,
          decoration: const BoxDecoration(
            color: Color(0xFF2E7D32),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.check_rounded,
            color: Colors.white,
            size: 32.sp,
          ),
        ),
      ),
    );
  }

  Widget _buildDetailCard() {
    String serviceName = "Coupe Homme";
    String dateStr = "Jeu. 10 Nov 2023 - 10:30";

    if (apiResponse != null) {
      final data = apiResponse!['data'];
      if (data != null) {
        final items = data['items'] as List<dynamic>?;
        if (items != null && items.isNotEmpty) {
          final firstItem = items.first;
          final service = firstItem['service'];
          if (service != null) {
            serviceName = service['service_name'] ?? "Service";
          }
        }

        final bookingDateStr = data['booking_date'] as String?;
        if (bookingDateStr != null) {
          try {
            final parsedDate = DateTime.parse(bookingDateStr);
            dateStr = DateFormat('EEE. d MMM yyyy', 'fr_FR')
                .format(parsedDate)
                .replaceFirstMapped(
                    RegExp(r'^[a-z]'), (m) => m[0]!.toUpperCase());
          } catch (e) {
            dateStr = bookingDateStr;
          }
        }
      }
    }

    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: AppColors.cFFFFFF,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.cEEEEEE, width: 1),
      ),
      child: Column(
        children: [
          _buildDetailRow(
            icon: Assets.icons.scissorsOutlinedGolden,
            text: serviceName,
          ),
          UIHelper.verticalSpace(16.h),
          _buildDetailRow(
            icon: Assets.icons.calendarOutlinedGolden,
            text: dateStr,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow({required AssetGenImage icon, required String text}) {
    return Row(
      children: [
        Container(
          width: 40.r,
          height: 40.r,
          padding: EdgeInsets.all(10.r),
          decoration: BoxDecoration(
            color: AppColors.cFFFFFF,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: AppColors.cEEEEEE, width: 1),
          ),
          child: icon.image(),
        ),
        UIHelper.horizontalSpace(16.w),
        Expanded(
          child:
              Text(text, style: TextFontStyle.textStyle16c1B1B1BInterTight500),
        ),
      ],
    );
  }
}

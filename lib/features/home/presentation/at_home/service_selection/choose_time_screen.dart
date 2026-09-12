import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tremley_cutomer/common_widgets/custom_back_app_bar.dart';
import 'package:tremley_cutomer/common_widgets/custom_button.dart';
import 'package:tremley_cutomer/constants/text_font_style.dart';
import 'package:tremley_cutomer/gen/assets.gen.dart';
import 'package:tremley_cutomer/gen/colors.gen.dart';
import 'package:tremley_cutomer/helpers/navigation_service.dart';
import 'package:tremley_cutomer/helpers/ui_helpers.dart';
import 'package:tremley_cutomer/helpers/all_routes.dart';
import 'package:tremley_cutomer/features/home/presentation/at_salon/widgets/booking_schedule/booking_calendar_section.dart';

class ChooseTimeScreen extends StatefulWidget {
  final int? salonId;
  final String providerType;
  final Map<String, dynamic>? bookingData;
  const ChooseTimeScreen(
      {super.key, this.salonId, this.providerType = "salon", this.bookingData});

  @override
  State<ChooseTimeScreen> createState() => _ChooseTimeScreenState();
}

class _ChooseTimeScreenState extends State<ChooseTimeScreen> {
  int _selectedOption = 0; // 0 for "Dès que possible", 1 for "Planifier"
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    if (widget.bookingData?['isLoyalty'] == true) {
      _selectedOption = 1; // Default to Planifier
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cFFFFFF,
      appBar: CustomBackAppBar(
        title: "Choisir l’horaire",
        onBack: () {
          NavigationService.goBackCall();
        },
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 0.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // As soon as possible option
                  if (widget.bookingData?['isLoyalty'] != true) ...[
                    _buildSelectionCard(
                      index: 0,
                      title: "Dès que possible",
                      subtitle:
                          "Nous vous envoyons un barbier dès que possible.",
                      isSelected: _selectedOption == 0,
                    ),
                    UIHelper.verticalSpace(16.h),
                  ],

                  // Schedule option
                  _buildSelectionCard(
                    index: 1,
                    title: "Planifier",
                    subtitle:
                        "Planifiez votre service à une date et heure précise.",
                    isSelected: _selectedOption == 1,
                  ),

                  UIHelper.verticalSpace(32.h),

                  // Content based on selection
                  if (_selectedOption == 0 &&
                      widget.bookingData?['isLoyalty'] != true)
                    _buildSearchStatusBox()
                  else ...[
                    BookingCalendarSection(
                      selectedDate: _selectedDate,
                      onDateChanged: (date) {
                        setState(() {
                          _selectedDate = date;
                        });
                      },
                    ),
                  ],
                ],
              ),
            ),
          ),

          // Bottom Continue Button
          SafeArea(
            child: Padding(
              padding: EdgeInsets.all(20.r),
              child: CustomButton(
                onPressed: () {
                  final updatedBookingData =
                      Map<String, dynamic>.from(widget.bookingData ?? {});
                  updatedBookingData['isASAP'] = _selectedOption == 0;
                  updatedBookingData['selectedDate'] = _selectedDate;

                  if (widget.bookingData?['isLoyalty'] == true) {
                    final services = updatedBookingData['selectedServices']
                        as List<dynamic>?;
                    int? barberId;
                    if (services != null && services.isNotEmpty) {
                      barberId = services[0].salonId ??
                          services[0].servicePrice?.createdBy;
                    }
                    updatedBookingData['barberId'] = barberId;

                    NavigationService.navigateToWithObject(
                      Routes.chooseBarberSlotScreen,
                      {
                        "selectedDate": _selectedDate,
                        "barberId": barberId,
                        "barberName": updatedBookingData['barberName'],
                        "barberImage": updatedBookingData['barberImage'],
                        "bookingData": updatedBookingData,
                      },
                    );
                  } else {
                    NavigationService.navigateToWithArgs(Routes.waitingScreen, {
                      'isASAP': _selectedOption == 0,
                      'selectedDate': _selectedDate,
                      'bookingData': updatedBookingData,
                    });
                  }
                },
                title: "Continuer",
                height: 55.h,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectionCard({
    required int index,
    required String title,
    required String subtitle,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedOption = index;
        });
      },
      child: Container(
        padding: EdgeInsets.all(20.r),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.cF6F6F6 : AppColors.cFFFFFF,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isSelected ? AppColors.cB08D2A : AppColors.cEEEEEE,
            width: 2.h,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style:
                        TextFontStyle.textStyle16c222222InterTight600.copyWith(
                      fontSize: 18.sp,
                    ),
                  ),
                  UIHelper.verticalSpace(4.h),
                  Text(
                    subtitle,
                    style: TextFontStyle.textStyle14c9B9B9BInterTight400,
                  ),
                ],
              ),
            ),
            UIHelper.horizontalSpace(16.w),
            // Custom Radio Indicator
            Container(
              width: 24.r,
              height: 24.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.cB08D2A : AppColors.cEEEEEE,
                  width: 2.h,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 12.r,
                        height: 12.r,
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

  Widget _buildSearchStatusBox() {
    return DottedBorder(
      color: AppColors.cB08D2A,
      strokeWidth: 1.h,
      dashPattern: const [6, 3],
      borderType: BorderType.RRect,
      radius: Radius.circular(20.r),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 40.h),
        decoration: BoxDecoration(
          color: AppColors.cFFFFFF,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Column(
          children: [
            // Lightning Icon in circle
            Container(
              width: 64.r,
              height: 64.r,
              decoration: BoxDecoration(
                color: AppColors.cB08D2A.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Assets.icons.lightningOutlinedGolden.image(
                  width: 32.r,
                  height: 32.r,
                ),
              ),
            ),
            UIHelper.verticalSpace(24.h),
            Text(
              "Recherche immédiate",
              style: TextFontStyle.textStyle16c222222InterTight600.copyWith(
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            UIHelper.verticalSpace(12.h),
            Text(
              "Nous recherchons un barbier disponible pour vous dès que possible dans votre secteur.",
              textAlign: TextAlign.center,
              style: TextFontStyle.textStyle14c9B9B9BInterTight400.copyWith(
                fontSize: 15.sp,
                height: 1.5,
              ),
            ),
            UIHelper.verticalSpace(32.h),
            // Estimated Waiting Pill
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: const Color(
                    0xFFFBF8F1), // Very light yellow/golden background
                borderRadius: BorderRadius.circular(100.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Assets.icons.clockOutlinedGolden.image(
                    width: 20.r,
                    height: 20.r,
                  ),
                  UIHelper.horizontalSpace(8.w),
                  Flexible(
                    child: Text(
                      "Temps d’attente estimé : 10—20 min",
                      style: TextFontStyle.textStyle14cB08D2AInterTight500
                          .copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:tremley_cutomer/common_widgets/app_network_image.dart';
import 'package:tremley_cutomer/common_widgets/custom_back_app_bar.dart';
import 'package:tremley_cutomer/common_widgets/custom_button.dart';
import 'package:tremley_cutomer/constants/text_font_style.dart';
import 'package:tremley_cutomer/gen/colors.gen.dart';
import 'package:tremley_cutomer/helpers/all_routes.dart';
import 'package:tremley_cutomer/helpers/navigation_service.dart';
import 'package:tremley_cutomer/helpers/ui_helpers.dart';
import 'package:tremley_cutomer/networks/api_acess.dart';
import 'package:tremley_cutomer/features/home/presentation/at_salon/widgets/booking_schedule/booking_time_slots_section.dart';
import 'package:tremley_cutomer/features/home/model/booking_slots_model.dart';
import 'package:shimmer/shimmer.dart';

class ChooseBarberSlotScreen extends StatefulWidget {
  final DateTime selectedDate;
  final int barberId;
  final String? barberName;
  final String? barberImage;
  final Map<String, dynamic> bookingData;

  const ChooseBarberSlotScreen({
    super.key,
    required this.selectedDate,
    required this.barberId,
    this.barberName,
    this.barberImage,
    required this.bookingData,
  });

  @override
  State<ChooseBarberSlotScreen> createState() => _ChooseBarberSlotScreenState();
}

class _ChooseBarberSlotScreenState extends State<ChooseBarberSlotScreen> {
  Slot? _selectedSlot;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      postBookingSlotsRxObj.fetchSlots(
        providerType: 'home_barber',
        date: DateFormat('yyyy-MM-dd').format(widget.selectedDate),
        barberId: widget.barberId,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cFFFFFF,
      appBar: CustomBackAppBar(
        title: "Choisir un créneau",
        onBack: () => NavigationService.goBackCall(),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBarberInfoCard(),
                  UIHelper.verticalSpace(24.h),
                  StreamBuilder<BookingSlotsModel>(
                    stream: postBookingSlotsRxObj.dataFetcher.stream,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: LayoutBuilder(builder: (context, constraints) {
                            double width = (constraints.maxWidth - 24.w) / 3;
                            return Wrap(
                              spacing: 12.w,
                              runSpacing: 12.h,
                              children: List.generate(6, (index) {
                                return Container(
                                  width: width,
                                  height: 48.h,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                );
                              }),
                            );
                          }),
                        );
                      }

                      final slots = snapshot.data?.data?.slots
                              ?.where((s) => s.isBooked == false)
                              .toList() ??
                          [];

                      if (slots.isEmpty && snapshot.hasData) {
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 20.h),
                          child: Center(
                            child: Text(
                              "Aucun créneau disponible pour cette date.",
                              style:
                                  TextFontStyle.textStyle14c9B9B9BInterTight400,
                            ),
                          ),
                        );
                      }

                      return BookingTimeSlotsSection(
                        slots: slots,
                        selectedSlot: _selectedSlot,
                        onSlotSelected: (slot) =>
                            setState(() => _selectedSlot = slot),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.all(20.r),
              child: CustomButton(
                onPressed: _selectedSlot == null
                    ? null
                    : () {
                        final updatedBookingData =
                            Map<String, dynamic>.from(widget.bookingData);
                        updatedBookingData['selectedTime'] =
                            _selectedSlot?.formattedTimeRange ?? "";
                        updatedBookingData['slotId'] = _selectedSlot?.slotId;
                        updatedBookingData['barberId'] = widget.barberId;

                        final services = updatedBookingData['selectedServices']
                            as List<dynamic>?;
                        String serviceName = "Service";
                        String duration = "30 min";
                        if (services != null && services.isNotEmpty) {
                          serviceName = services[0].serviceName ?? "Service";
                          duration =
                              "${services[0].servicePrice?.timeDuration ?? '30'} min";
                        }

                        NavigationService.navigateToWithObject(
                          Routes.bookingConfirmationScreen,
                          {
                            "salonName":
                                widget.barberName ?? "Barbier à domicile",
                            "serviceName": serviceName,
                            "duration": duration,
                            "dateTime":
                                "${DateFormat('dd MMMM yyyy', 'fr_FR').format(widget.selectedDate)} à ${_selectedSlot?.formattedTimeRange}",
                            "price": "0 €",
                            "bookingData": updatedBookingData,
                            "isLoyalty": true,
                            "loyaltyServiceId":
                                updatedBookingData['loyaltyServiceId'],
                          },
                        );
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

  Widget _buildBarberInfoCard() {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.cFFFFFF,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppColors.cB08D2A,
          width: 1.5.h,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48.r,
            height: 48.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.cF9F9F9,
            ),
            child: AppNetworkImage(
              imageUrl: widget.barberImage ?? '',
              height: 48.r,
              width: 48.r,
              isProfilePicture: true,
            ),
          ),
          UIHelper.horizontalSpace(12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.barberName ?? "Barbier",
                  style: TextFontStyle.textStyle16c191919Inter600.copyWith(
                    fontSize: 18.sp,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 24.r,
            height: 24.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.cB08D2A,
                width: 2.h,
              ),
            ),
            child: Center(
              child: Container(
                width: 12.r,
                height: 12.r,
                decoration: const BoxDecoration(
                  color: AppColors.cB08D2A,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

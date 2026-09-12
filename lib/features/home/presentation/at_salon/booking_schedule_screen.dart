import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:tremley_cutomer/common_widgets/custom_back_app_bar.dart';
import 'package:tremley_cutomer/common_widgets/custom_button.dart';
import 'package:tremley_cutomer/gen/colors.gen.dart';
import 'package:tremley_cutomer/helpers/ui_helpers.dart';
import '../shimmers/booking_time_slots_shimmer.dart';
import 'widgets/booking_schedule/booking_summary_card.dart';
import 'widgets/booking_schedule/booking_calendar_section.dart';
import 'widgets/booking_schedule/booking_time_slots_section.dart';
import 'package:tremley_cutomer/helpers/all_routes.dart';
import 'package:tremley_cutomer/helpers/navigation_service.dart';
import 'package:tremley_cutomer/networks/api_acess.dart';
import '../../model/booking_slots_model.dart';

class BookingScheduleScreen extends StatefulWidget {
  final int salonId;
  final int? barberId;
  final String providerType; // Changed from hardcoded to dynamic
  final String salonName;
  final String serviceName;
  final String duration;
  final String price;
  final String? barberName;
  final String? barberImage;
  final double? barberRating;
  final Map<String, dynamic> bookingData;
  final bool isLoyalty;
  final int? loyaltyServiceId;

  const BookingScheduleScreen({
    super.key,
    required this.salonId,
    this.barberId,
    this.providerType = "salon",
    required this.salonName,
    required this.serviceName,
    required this.duration,
    required this.price,
    this.barberName,
    this.barberImage,
    this.barberRating,
    required this.bookingData,
    this.isLoyalty = false,
    this.loyaltyServiceId,
  });

  @override
  State<BookingScheduleScreen> createState() => _BookingScheduleScreenState();
}

class _BookingScheduleScreenState extends State<BookingScheduleScreen> {
  DateTime _selectedDate = DateTime.now();
  Slot? _selectedSlot;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchSlots();
    });
  }

  Future<void> _fetchSlots() async {
    await postBookingSlotsRxObj.fetchSlots(
      providerType: widget.providerType,
      salonId: widget.salonId,
      date: DateFormat('yyyy-MM-dd').format(_selectedDate),
      barberId: widget.barberId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cFFFFFF,
      appBar: const CustomBackAppBar(title: "Rendez-vous"),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  UIHelper.verticalSpace(12.h),
                  BookingSummaryCard(
                    salonName: widget.salonName,
                    serviceName: widget.serviceName,
                    duration: widget.duration,
                    price: widget.price,
                    barberName: widget.barberName ?? "Automatique",
                    barberImage: widget.barberImage ?? "",
                    barberRating: widget.barberRating ?? 4.9,
                  ),
                  UIHelper.verticalSpace(24.h),
                  BookingCalendarSection(
                    selectedDate: _selectedDate,
                    onDateChanged: (date) {
                      setState(() {
                        _selectedDate = date;
                        _selectedSlot = null;
                      });
                      _fetchSlots();
                    },
                  ),
                  UIHelper.verticalSpace(24.h),
                  StreamBuilder<BookingSlotsModel>(
                    stream: postBookingSlotsRxObj.dataFetcher.stream,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const BookingTimeSlotsShimmer();
                      }

                      final slots = snapshot.data?.data?.slots
                              ?.where((s) => s.isBooked == false)
                              .toList() ??
                          [];

                      return BookingTimeSlotsSection(
                        slots: slots,
                        selectedSlot: _selectedSlot,
                        onSlotSelected: (slot) =>
                            setState(() => _selectedSlot = slot),
                      );
                    },
                  ),
                  UIHelper.verticalSpace(20.h),
                ],
              ),
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: AppColors.cEEEEEE, width: 1),
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 16.h),
                child: CustomButton(
                  onPressed: _selectedSlot == null
                      ? null
                      : () {
                          final updatedBookingData =
                              Map<String, dynamic>.from(widget.bookingData);
                          updatedBookingData['selectedDate'] = _selectedDate;
                          updatedBookingData['selectedTime'] =
                              _selectedSlot?.formattedTimeRange ?? "";
                          updatedBookingData['slotId'] = _selectedSlot?.slotId;

                          NavigationService.navigateToWithObject(
                            Routes.bookingConfirmationScreen,
                            {
                              "salonName": widget.salonName,
                              "serviceName": widget.serviceName,
                              "duration": widget.duration,
                              "dateTime":
                                  "${DateFormat('dd MMMM yyyy', 'fr_FR').format(_selectedDate)} à ${_selectedSlot?.formattedTimeRange}",
                              "price": widget.price,
                              "bookingData": updatedBookingData,
                              "isLoyalty": widget.isLoyalty,
                              "loyaltyServiceId": widget.loyaltyServiceId,
                            },
                          );
                        },
                  title: "Continuer",
                  height: 56.h,
                  backgroundColor: AppColors.c222222,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

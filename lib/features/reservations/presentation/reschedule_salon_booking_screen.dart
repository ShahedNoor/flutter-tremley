import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:tremley_cutomer/common_widgets/custom_back_app_bar.dart';
import 'package:tremley_cutomer/common_widgets/custom_button.dart';

import 'package:tremley_cutomer/gen/colors.gen.dart';
import 'package:tremley_cutomer/helpers/ui_helpers.dart';
import 'package:tremley_cutomer/common_widgets/waiting_widget.dart';
import 'package:tremley_cutomer/networks/api_acess.dart';
import 'package:tremley_cutomer/networks/dio/dio.dart';
import 'package:tremley_cutomer/features/home/presentation/shimmers/booking_time_slots_shimmer.dart';
import 'package:tremley_cutomer/networks/endpoints.dart';
import 'reservations_screen.dart';
import '../../../common_widgets/custom_toast.dart';
import '../../home/presentation/at_salon/widgets/service_selection/service_selection_header.dart';

import '../../home/presentation/at_salon/widgets/booking_schedule/booking_calendar_section.dart';
import '../../home/presentation/at_salon/widgets/booking_schedule/booking_time_slots_section.dart';
import '../../home/model/service_list_model.dart';
import '../../home/model/barber_list_model.dart';
import '../../home/model/booking_slots_model.dart';

class RescheduleSalonBookingScreen extends StatefulWidget {
  final int bookingId;
  final int salonId;
  final String salonName;
  final String providerType;
  final int? barberId;
  final String? barberName;

  const RescheduleSalonBookingScreen({
    super.key,
    required this.bookingId,
    required this.salonId,
    required this.salonName,
    this.providerType = "salon",
    this.barberId,
    this.barberName,
  });

  @override
  State<RescheduleSalonBookingScreen> createState() =>
      _RescheduleSalonBookingScreenState();
}

class _RescheduleSalonBookingScreenState
    extends State<RescheduleSalonBookingScreen> {
  Barber? _selectedBarber;

  DateTime _selectedDate = DateTime.now();
  Slot? _selectedSlot;

  @override
  void initState() {
    super.initState();
    if (widget.barberId != null) {
      _selectedBarber = Barber(id: widget.barberId, name: widget.barberName);
    }
    _fetchInitialData();
  }

  void _fetchInitialData() {
    getBarberListRxObj.fetchBarberList(widget.salonId);
    getSalonServiceListRxObj.fetchSalonServiceList(widget.salonId);
    _fetchSlots();
  }

  Future<void> _fetchSlots() async {
    postBookingSlotsRxObj.clean();
    await postBookingSlotsRxObj.fetchSlots(
      providerType: widget.providerType,
      salonId: widget.salonId,
      date: DateFormat('yyyy-MM-dd').format(_selectedDate),
      barberId: _selectedBarber?.id,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cFFFFFF,
      appBar: const CustomBackAppBar(title: "Modifier le rendez-vous"),
      body: StreamBuilder<ServiceListModel>(
        stream: getSalonServiceListRxObj.dataFetcher.stream,
        builder: (context, serviceSnapshot) {
          if (serviceSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: WaitingWidget());
          }
          if (serviceSnapshot.hasError ||
              !serviceSnapshot.hasData ||
              serviceSnapshot.data?.data == null) {
            return const Center(
                child: Text("Erreur de chargement des services."));
          }

          final services = serviceSnapshot.data!.data;
          if (services.isEmpty) {
            return const Center(child: Text("Aucun service disponible."));
          }

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      UIHelper.verticalSpace(20.h),
                      ServiceSelectionHeader(
                        salonName: widget.salonName,
                        rating: 0.0,
                        distance: 0.0,
                        address: "",
                        hideAutoOption: true,
                        selectedBarber: _selectedBarber,
                        onBarberSelected: (val) {
                          setState(() {
                            _selectedBarber = val;
                            _selectedSlot = null; // Reset slot
                          });
                          _fetchSlots();
                        },
                      ),
                      UIHelper.verticalSpace(24.h),
                      BookingCalendarSection(
                        selectedDate: _selectedDate,
                        onDateChanged: (date) {
                          setState(() {
                            _selectedDate = date;
                            _selectedSlot = null; // Reset slot
                          });
                          _fetchSlots();
                        },
                      ),
                      UIHelper.verticalSpace(24.h),
                      StreamBuilder<BookingSlotsModel>(
                        stream: postBookingSlotsRxObj.dataFetcher.stream,
                        builder: (context, slotSnapshot) {
                          if (slotSnapshot.connectionState ==
                                  ConnectionState.waiting ||
                              (slotSnapshot.hasData &&
                                  slotSnapshot.data?.status == null &&
                                  !slotSnapshot.hasError)) {
                            return const BookingTimeSlotsShimmer();
                          }
                          if (slotSnapshot.hasError || !slotSnapshot.hasData) {
                            return const Center(
                                child: Text("Aucun créneau disponible."));
                          }

                          final slots = slotSnapshot.data?.data?.slots ?? [];
                          return BookingTimeSlotsSection(
                            slots: slots,
                            selectedSlot: _selectedSlot,
                            onSlotSelected: (slot) =>
                                setState(() => _selectedSlot = slot),
                          );
                        },
                      ),
                      UIHelper.verticalSpace(40.h),
                    ],
                  ),
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                  border: Border(
                      top: BorderSide(color: AppColors.cEEEEEE, width: 1)),
                ),
                padding: EdgeInsets.all(20.r),
                child: SafeArea(
                  child: CustomButton(
                    onPressed: _selectedSlot == null
                        ? null
                        : () async {
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) => const WaitingWidget(),
                            );

                            try {
                              Map<String, dynamic> data = {
                                "date": DateFormat('yyyy-MM-dd')
                                    .format(_selectedDate),
                                "slot_id": [_selectedSlot!.slotId],
                                "barber_id": _selectedBarber?.id ?? 0,
                              };

                              final response = await postHttp(
                                Endpoints.rescheduleBooking(widget.bookingId),
                                data,
                              );

                              if (context.mounted) {
                                Navigator.pop(context); // close dialog
                              }

                              if (response.data['status'] == true) {
                                customToastMessage(
                                    "Succès",
                                    response.data['message'] ??
                                        "Réservation modifiée.");
                                ReservationsScreenState.instance?.fetchData();
                                if (context.mounted) {
                                  Navigator.pop(context); // go back
                                }
                              } else {
                                customToastMessage(
                                    "Erreur",
                                    response.data['message'] ??
                                        "Échec de la modification.");
                              }
                            } catch (e) {
                              if (context.mounted) {
                                Navigator.pop(context); // close dialog
                              }
                              customToastMessage(
                                  "Erreur", "Échec de la modification.");
                            }
                          },
                    title: "Confirmer la modification",
                    height: 55.h,
                    backgroundColor: _selectedSlot == null
                        ? AppColors.c737373
                        : AppColors.allPrimaryColor,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

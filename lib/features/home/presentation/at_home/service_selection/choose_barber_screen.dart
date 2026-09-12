import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tremley_cutomer/common_widgets/app_network_image.dart';
import 'package:tremley_cutomer/common_widgets/custom_back_app_bar.dart';
import 'package:tremley_cutomer/common_widgets/custom_button.dart';
import 'package:tremley_cutomer/constants/text_font_style.dart';
import 'package:tremley_cutomer/gen/assets.gen.dart';
import 'package:tremley_cutomer/gen/colors.gen.dart';
import 'package:tremley_cutomer/helpers/all_routes.dart';
import 'package:tremley_cutomer/helpers/navigation_service.dart';
import 'package:tremley_cutomer/helpers/ui_helpers.dart';
import 'package:tremley_cutomer/networks/api_acess.dart';
import 'package:tremley_cutomer/features/home/model/home_barber_search_list_model.dart';
import 'package:tremley_cutomer/features/home/presentation/at_salon/widgets/booking_schedule/booking_time_slots_section.dart';
import 'package:tremley_cutomer/features/home/model/booking_slots_model.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tremley_cutomer/common_widgets/custom_toast.dart';
import 'package:tremley_cutomer/helpers/loading_helper.dart';
import 'package:tremley_cutomer/features/home/model/service_list_model.dart';

class ChooseBarberScreen extends StatefulWidget {
  final DateTime? selectedDate;
  final String? selectedTime;
  final Map<String, dynamic>? bookingData;
  const ChooseBarberScreen(
      {super.key, this.selectedDate, this.selectedTime, this.bookingData});

  @override
  State<ChooseBarberScreen> createState() => _ChooseBarberScreenState();
}

class _ChooseBarberScreenState extends State<ChooseBarberScreen> {
  int _selectedIndex = 0; // 0 for "Aucune préférence", 1+ for barbers
  Slot? _selectedSlot;

  List<HomeBarber> _barbers = [];

  @override
  void initState() {
    super.initState();
    _barbers =
        postHomeBarberSearchListRxObj.dataFetcher.valueOrNull?.data ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cFFFFFF,
      appBar: CustomBackAppBar(
        title: "Choisir un barbier",
        onBack: () => NavigationService.goBackCall(),
        actions: [
          GestureDetector(
            onTap: () => _showSearchOverlay(context),
            child: Padding(
              padding: EdgeInsets.only(right: UIHelper.kDefaulutPadding()),
              child: Icon(
                Icons.search_rounded,
                color: AppColors.c000000,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20.r),
              child: Column(
                children: [
                  // "Aucune préférence" Option
                  _buildBarberOption(
                    index: 0,
                    title: "Aucune préférence",
                    subtitle: "Le plus rapide disponible",
                    icon: Assets.icons.profileDoubleOutlinedBlack.image(
                      width: 24.w,
                      height: 24.w,
                    ),
                  ),
                  UIHelper.verticalSpace(16.h),

                  // Barber List
                  ...List.generate(_barbers.length, (index) {
                    final barber = _barbers[index];
                    return Padding(
                      padding: EdgeInsets.only(bottom: 16.h),
                      child: _buildBarberOption(
                        index: index + 1,
                        title: barber.name ?? "",
                        rating:
                            5.0, // Default rating as API doesn't provide one
                        imageUrl: barber.profileImage,
                        barber: barber,
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),

          // Bottom Continue Button
          SafeArea(
            child: Padding(
              padding: EdgeInsets.all(20.r),
              child: CustomButton(
                onPressed: (_selectedIndex > 0 && _selectedSlot == null)
                    ? null
                    : () async {
                        final updatedBookingData =
                            Map<String, dynamic>.from(widget.bookingData ?? {});

                        if (_selectedIndex == 0) {
                          updatedBookingData['barberName'] = "Automatique";
                          updatedBookingData['barberImage'] = "";
                          updatedBookingData['barberRating'] = 4.9;
                          updatedBookingData['barberId'] = null;
                          updatedBookingData['selectedTime'] = null;
                          updatedBookingData['slotId'] = null;
                        } else {
                          final barber = _barbers[_selectedIndex - 1];
                          updatedBookingData['barberName'] = barber.name;
                          updatedBookingData['barberImage'] =
                              barber.profileImage ?? "";
                          updatedBookingData['barberRating'] = 5.0;
                          updatedBookingData['barberId'] = barber.id;
                          updatedBookingData['selectedTime'] =
                              _selectedSlot?.formattedTimeRange;
                          updatedBookingData['slotId'] = _selectedSlot?.slotId;
                        }

                        // Extract service IDs, quantities, and prices from selectedServices
                        final services = updatedBookingData['selectedServices']
                            as List<dynamic>?;
                        List<int> serviceIds = [];
                        List<int> quantities = [];
                        List<double> prices = [];
                        double subtotal = 0.0;
                        double totalPrice = 0.0;

                        if (services != null) {
                          for (var s in services) {
                            if (s is ServiceItem) {
                              serviceIds.add(s.id ?? 0);
                              quantities.add(s.quantity);

                              double originalPrice = double.tryParse(
                                      s.servicePrice?.price ?? '0') ??
                                  0.0;
                              double discount = double.tryParse(
                                      s.servicePrice?.discount ?? '0') ??
                                  0.0;
                              double finalPrice = originalPrice - discount;
                              if (finalPrice < 0) finalPrice = 0;

                              prices.add(finalPrice);
                              subtotal += finalPrice * s.quantity;
                              totalPrice += originalPrice * s.quantity;
                            }
                          }
                        } else {
                          double price = (updatedBookingData['totalPrice'] ?? 0)
                              .toDouble();
                          prices.add(price);
                          subtotal = price;
                          totalPrice = price;
                        }

                        String formattedDate = "";
                        if (widget.selectedDate != null) {
                          formattedDate = DateFormat('yyyy-MM-dd')
                              .format(widget.selectedDate!);
                        }

                        final payload = {
                          "date": formattedDate,
                          "customer_id": getProfileRxObj
                                  .dataFetcher.valueOrNull?.data?.user?.id ??
                              9,
                          "barber_id": updatedBookingData['barberId'],
                          "payment_type": "online",
                          "booking_type": "online",
                          "request_type": "home_barber",
                          "quantity": quantities,
                          "slot_id": updatedBookingData['slotId'] != null
                              ? [updatedBookingData['slotId']]
                              : [],
                          "service_id": serviceIds,
                          "price": prices,
                          "subtotal": subtotal,
                          "tax": 0,
                          "total_price": totalPrice,
                        };

                        final res = await postCustomerBookingRxObj
                            .postBooking(data: payload)
                            .waitingForFutureWithoutBg();

                        if (res['data'] != null &&
                            res['data'] is Map &&
                            res['data'].isNotEmpty) {
                          if (res['data']['payment_url'] != null) {
                            NavigationService.navigateToWithObject(
                                Routes.stripePaymentLaunchScreen, {
                              'paymentUrl': res['data']['payment_url'],
                              'bookingId': res['data']['booking_id']
                            });
                          } else {
                            NavigationService.navigateTo(
                                Routes.bookingSuccessScreen);
                          }
                        } else {
                          customToastMessage("Erreur",
                              res['message'] ?? "Réservation échouée.");
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

  Widget _buildBarberOption({
    required int index,
    required String title,
    String? subtitle,
    double? rating,
    String? imageUrl,
    Widget? icon,
    HomeBarber? barber,
  }) {
    bool isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
          _selectedSlot = null;
        });
        if (index > 0 && barber != null) {
          postBookingSlotsRxObj.fetchSlots(
            providerType: 'home_barber',
            date: DateFormat('yyyy-MM-dd')
                .format(widget.selectedDate ?? DateTime.now()),
            barberId: barber.id,
          );
        }
      },
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: AppColors.cFFFFFF,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected ? AppColors.cB08D2A : AppColors.cEEEEEE,
            width: isSelected ? 1.5.h : 1.h,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Barber Image or Icon
                Container(
                  width: 48.r,
                  height: 48.r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.cF9F9F9,
                  ),
                  child:
                      (imageUrl != null && imageUrl.isNotEmpty) || icon == null
                          ? AppNetworkImage(
                              imageUrl: imageUrl ?? '',
                              height: 48.r,
                              width: 48.r,
                              isProfilePicture: true,
                            )
                          : Center(child: icon),
                ),
                UIHelper.horizontalSpace(12.w),

                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style:
                            TextFontStyle.textStyle16c191919Inter600.copyWith(
                          fontSize: 18.sp,
                        ),
                      ),
                      if (subtitle != null) ...[
                        UIHelper.verticalSpace(4.h),
                        Text(
                          subtitle,
                          style: TextFontStyle.textStyle14c9B9B9BInterTight400,
                        ),
                      ],
                      if (rating != null) ...[
                        UIHelper.verticalSpace(4.h),
                        Row(
                          children: [
                            Assets.icons.starYellow.image(
                              width: 14.w,
                              height: 14.w,
                            ),
                            UIHelper.horizontalSpace(4.w),
                            Text(
                              rating.toString(),
                              style: TextFontStyle.textStyle14c191919Inter500
                                  .copyWith(
                                color: AppColors.c4D4D4D,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),

                // Selection Indicator
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
            if (isSelected && index > 0) ...[
              UIHelper.verticalSpace(16.h),
              StreamBuilder<BookingSlotsModel>(
                stream: postBookingSlotsRxObj.dataFetcher.stream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 24.h,
                            width: 150.w,
                            color: Colors.white,
                          ),
                          UIHelper.verticalSpace(16.h),
                          LayoutBuilder(builder: (context, constraints) {
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
                        ],
                      ),
                    );
                  }

                  final slots = snapshot.data?.data?.slots
                          ?.where((s) => s.isBooked == false)
                          .toList() ??
                      [];

                  if (slots.isEmpty && snapshot.hasData) {
                    return const Text("Aucun créneau disponible");
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
          ],
        ),
      ),
    );
  }

  void _showSearchOverlay(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierColor: Colors.black87,
      barrierDismissible: true,
      barrierLabel: "Rechercher",
      pageBuilder: (context, animation, secondaryAnimation) {
        return _BarberSearchOverlay(
          allBarbers: _barbers,
          onSelect: (barber) {
            Navigator.pop(context);
            final index = _barbers.indexWhere((b) => b.id == barber.id);
            if (index != -1) {
              setState(() {
                _selectedIndex = index + 1;
                _selectedSlot = null;
              });
              postBookingSlotsRxObj.fetchSlots(
                providerType: 'home_barber',
                date: DateFormat('yyyy-MM-dd')
                    .format(widget.selectedDate ?? DateTime.now()),
                barberId: barber.id,
              );
            }
          },
        );
      },
    );
  }
}

class _BarberSearchOverlay extends StatefulWidget {
  final List<HomeBarber> allBarbers;
  final Function(HomeBarber) onSelect;

  const _BarberSearchOverlay(
      {required this.allBarbers, required this.onSelect});

  @override
  State<_BarberSearchOverlay> createState() => _BarberSearchOverlayState();
}

class _BarberSearchOverlayState extends State<_BarberSearchOverlay> {
  final TextEditingController _searchController = TextEditingController();
  List<HomeBarber> _filteredBarbers = [];

  @override
  void initState() {
    super.initState();
    _filteredBarbers = widget.allBarbers;
  }

  void _onSearch(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredBarbers = widget.allBarbers;
      } else {
        _filteredBarbers = widget.allBarbers
            .where((b) =>
                (b.name ?? '').toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(20.r),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onChanged: _onSearch,
                      style: TextFontStyle.textStyle16c191919Inter600
                          .copyWith(color: Colors.white),
                      cursorColor: Colors.white,
                      autofocus: true,
                      decoration: InputDecoration(
                        hintText: "Rechercher un barbier...",
                        hintStyle:
                            TextFontStyle.textStyle14c9B9B9BInterTight400,
                        prefixIcon:
                            const Icon(Icons.search, color: Colors.white70),
                        filled: true,
                        fillColor: Colors.white.withValues(alpha: 0.1),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  UIHelper.horizontalSpace(12.w),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Text(
                      "Annuler",
                      style: TextFontStyle.textStyle14c191919Inter500
                          .copyWith(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 20.r),
                itemCount: _filteredBarbers.length,
                itemBuilder: (context, index) {
                  final barber = _filteredBarbers[index];
                  return ListTile(
                    contentPadding: EdgeInsets.only(bottom: 16.h),
                    leading: CircleAvatar(
                      radius: 24.r,
                      backgroundImage: (barber.profileImage != null &&
                              barber.profileImage!.isNotEmpty)
                          ? NetworkImage(barber.profileImage!)
                          : null,
                      backgroundColor: Colors.white24,
                      child: (barber.profileImage == null ||
                              barber.profileImage!.isEmpty)
                          ? const Icon(Icons.person, color: Colors.white)
                          : null,
                    ),
                    title: Text(
                      barber.name ?? "",
                      style: TextFontStyle.textStyle16c191919Inter600
                          .copyWith(color: Colors.white),
                    ),
                    onTap: () => widget.onSelect(barber),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

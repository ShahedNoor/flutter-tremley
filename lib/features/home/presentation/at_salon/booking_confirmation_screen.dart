import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tremley_cutomer/common_widgets/custom_back_app_bar.dart';
import 'package:tremley_cutomer/common_widgets/custom_button.dart';
import 'package:tremley_cutomer/constants/text_font_style.dart';
import 'package:tremley_cutomer/gen/colors.gen.dart';
import 'package:tremley_cutomer/helpers/ui_helpers.dart';
import '../../model/service_list_model.dart';
import 'widgets/booking_confirmation/booking_selection_summary.dart';
import 'widgets/booking_confirmation/payment_method_selector.dart';
import 'package:tremley_cutomer/helpers/all_routes.dart';
import 'package:tremley_cutomer/helpers/navigation_service.dart';
import 'package:tremley_cutomer/helpers/loading_helper.dart';
import 'package:tremley_cutomer/networks/api_acess.dart';
import 'package:tremley_cutomer/common_widgets/custom_toast.dart';
import 'package:intl/intl.dart';

class BookingConfirmationScreen extends StatefulWidget {
  final String salonName;
  final String serviceName;
  final String duration;
  final String dateTime;
  final String price;
  final Map<String, dynamic>? bookingData;
  final bool isLoyalty;
  final int? loyaltyServiceId;

  const BookingConfirmationScreen({
    super.key,
    required this.salonName,
    required this.serviceName,
    required this.duration,
    required this.dateTime,
    required this.price,
    this.bookingData,
    this.isLoyalty = false,
    this.loyaltyServiceId,
  });

  @override
  State<BookingConfirmationScreen> createState() =>
      _BookingConfirmationScreenState();
}

class _BookingConfirmationScreenState extends State<BookingConfirmationScreen> {
  int _selectedPaymentIndex = 0; // 0 for Online, 1 for On-site

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cFFFFFF,
      appBar: const CustomBackAppBar(title: "Confirmation"),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  UIHelper.verticalSpace(24.h),
                  BookingSelectionSummary(
                    salonName: widget.salonName,
                    serviceName: widget.serviceName,
                    duration: widget.duration,
                    dateTime: widget.dateTime,
                    price: widget.price,
                  ),
                  UIHelper.verticalSpace(32.h),
                  if (!widget.isLoyalty) ...[
                    Text("Moyen de paiement",
                        style: TextFontStyle.textStyle20c1B1B1BInterTight600),
                    UIHelper.verticalSpace(16.h),
                    PaymentMethodSelector(
                      selectedIndex: _selectedPaymentIndex,
                      onChanged: (index) =>
                          setState(() => _selectedPaymentIndex = index),
                    ),
                  ],
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
                  onPressed: () async {
                    String formattedDate = "";
                    if (widget.bookingData?['selectedDate'] != null) {
                      formattedDate = DateFormat('yyyy-MM-dd').format(
                          widget.bookingData!['selectedDate'] as DateTime);
                    }

                    String providerType =
                        widget.bookingData?['providerType'] ?? "salon";
                    String requestType = providerType;
                    if (providerType == "salon") {
                      if (widget.bookingData?['barberId'] != null) {
                        requestType = "salon_barber";
                      } else {
                        requestType = "salon_auto";
                      }
                    }

                    if (widget.isLoyalty) {
                      final loyaltyPayload = <String, dynamic>{
                        "date": formattedDate,
                        "customer_id": getProfileRxObj
                                .dataFetcher.valueOrNull?.data?.user?.id ??
                            9,
                        "slot_id": widget.bookingData?['slotId'] != null
                            ? [widget.bookingData!['slotId']]
                            : [],
                      };

                      if (widget.bookingData?['barberId'] != null) {
                        loyaltyPayload["barber_id"] =
                            widget.bookingData!['barberId'];
                      }

                      if (widget.bookingData?['salonId'] != null) {
                        loyaltyPayload["salon_id"] =
                            widget.bookingData!['salonId'];
                        loyaltyPayload["type"] = "salon";
                      }

                      final res = await postLoyaltyBookingRxObj
                          .postLoyaltyBooking(data: loyaltyPayload)
                          .waitingForFutureWithoutBg();

                      if (res['status'] == 'success' || res['status'] == true) {
                        NavigationService.navigateToWithObject(
                          Routes.atSalonBookingSuccessScreen,
                          {
                            "salonName": widget.salonName,
                            "serviceName": widget.serviceName,
                            "duration": widget.duration,
                            "dateTime": widget.dateTime,
                          },
                        );
                      } else {
                        customToastMessage("Réservation échouée",
                            res['message'] ?? "Veuillez réessayer.");
                      }
                      return;
                    }

                    final selectedServices = widget
                        .bookingData?['selectedServices'] as List<dynamic>?;

                    List<int> serviceIds = [];
                    List<int> quantities = [];
                    List<double> prices = [];
                    double subtotal = 0.0;
                    double totalPrice = 0.0;

                    if (selectedServices != null &&
                        selectedServices.isNotEmpty) {
                      for (var s in selectedServices) {
                        if (s is ServiceItem) {
                          serviceIds.add(s.id ?? 0);
                          quantities.add(s.quantity);

                          double originalPrice =
                              double.tryParse(s.servicePrice?.price ?? '0') ??
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
                      if (widget.bookingData?['serviceId'] != null) {
                        serviceIds.add(widget.bookingData!['serviceId']);
                      }
                      quantities.add(1);
                      double price =
                          (widget.bookingData?['totalPrice'] ?? 0.0).toDouble();
                      prices.add(price);
                      subtotal = price;
                      totalPrice = price;
                    }

                    final payload = {
                      "date": formattedDate,
                      "customer_id": getProfileRxObj
                              .dataFetcher.valueOrNull?.data?.user?.id ??
                          9,
                      "salon_id": widget.bookingData?['salonId'],
                      "barber_id": widget.bookingData?['barberId'],
                      "payment_type":
                          _selectedPaymentIndex == 0 ? "online" : "cod",
                      "booking_type":
                          _selectedPaymentIndex == 0 ? "online" : "cod",
                      "request_type": requestType,
                      "quantity": quantities,
                      "slot_id": widget.bookingData?['slotId'] != null
                          ? [widget.bookingData!['slotId']]
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
                        NavigationService.navigateToWithObject(
                          Routes.atSalonBookingSuccessScreen,
                          {
                            "salonName": widget.salonName,
                            "serviceName": widget.serviceName,
                            "duration": widget.duration,
                            "dateTime": widget.dateTime,
                          },
                        );
                      }
                    } else {
                      customToastMessage("Réservation échouée",
                          res['message'] ?? "Veuillez réessayer.");
                    }
                  },
                  title: "Confirmer la réservation",
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

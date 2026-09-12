import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tremley_cutomer/common_widgets/custom_back_app_bar.dart';
import 'package:tremley_cutomer/common_widgets/custom_button.dart';
import 'package:tremley_cutomer/constants/text_font_style.dart';
import 'package:tremley_cutomer/gen/colors.gen.dart';
import 'package:tremley_cutomer/helpers/navigation_service.dart';
import 'package:tremley_cutomer/helpers/ui_helpers.dart';
import 'package:tremley_cutomer/helpers/all_routes.dart';
import 'package:tremley_cutomer/networks/api_acess.dart';
import 'package:tremley_cutomer/features/home/model/service_list_model.dart';
import 'package:tremley_cutomer/common_widgets/custom_toast.dart';
import 'package:tremley_cutomer/helpers/loading_helper.dart';
import 'package:intl/intl.dart';
import 'widgets/payment/payment_barber_card.dart';
import 'widgets/payment/payment_form_box.dart';
import 'widgets/payment/payment_summary_card.dart';

class PaymentScreen extends StatelessWidget {
  final Map<String, dynamic>? bookingData;
  const PaymentScreen({super.key, this.bookingData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cFFFFFF,
      appBar: CustomBackAppBar(
        title: "Paiement",
        onBack: () {
          NavigationService.goBackCall();
        },
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Récapitulatif",
                      style: TextFontStyle.textStyle20c222222InterTight600),
                  UIHelper.verticalSpace(8.h),
                  if (bookingData?['selectedDate'] != null &&
                      bookingData?['selectedTime'] != null)
                    Text(
                      "${DateFormat('dd MMMM yyyy', 'fr_FR').format(bookingData!['selectedDate'] as DateTime)} • ${bookingData!['selectedTime']}",
                      style: TextFontStyle.textStyle14c8A8A8AInter400,
                    ),
                  UIHelper.verticalSpace(16.h),

                  // Summary Card Component
                  PaymentSummaryCard(
                    selectedServices:
                        bookingData?['selectedServices'] as List<dynamic>?,
                    totalPrice: bookingData?['totalPrice'] as double?,
                  ),

                  UIHelper.verticalSpace(16.h),

                  // Barber Info Card Component
                  PaymentBarberCard(
                    barberName: bookingData?['barberName'] ?? "Automatique",
                    barberImage: bookingData?['barberImage'] ?? "",
                    barberRating:
                        (bookingData?['barberRating'] as num?)?.toDouble() ??
                            4.9,
                  ),

                  if (bookingData?['isLoyalty'] != true) ...[
                    UIHelper.verticalSpace(32.h),
                    Text("Moyen de paiement",
                        style: TextFontStyle.textStyle20c222222InterTight600),
                    UIHelper.verticalSpace(16.h),
                    // Payment Form Component
                    const PaymentFormBox(),
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
                onPressed: () async {
                  final services =
                      bookingData?['selectedServices'] as List<dynamic>?;
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

                        double originalPrice =
                            double.tryParse(s.servicePrice?.price ?? '0') ??
                                0.0;
                        double discount =
                            double.tryParse(s.servicePrice?.discount ?? '0') ??
                                0.0;
                        double finalPrice = originalPrice - discount;
                        if (finalPrice < 0) finalPrice = 0;

                        prices.add(finalPrice);
                        subtotal += finalPrice * s.quantity;
                        totalPrice += originalPrice * s.quantity;
                      }
                    }
                  } else {
                    double price = (bookingData?['totalPrice'] ?? 0).toDouble();
                    prices.add(price);
                    subtotal = price;
                    totalPrice = price;
                  }

                  String formattedDate = "";
                  if (bookingData?['selectedDate'] != null) {
                    formattedDate = DateFormat('yyyy-MM-dd')
                        .format(bookingData!['selectedDate'] as DateTime);
                  }

                  if (bookingData?['isLoyalty'] == true) {
                    final loyaltyPayload = <String, dynamic>{
                      "date": formattedDate,
                      "customer_id": getProfileRxObj
                              .dataFetcher.valueOrNull?.data?.user?.id ??
                          9,
                      "slot_id": bookingData?['slotId'] != null
                          ? [bookingData!['slotId']]
                          : [],
                    };

                    if (bookingData?['barberId'] != null) {
                      loyaltyPayload["barber_id"] = bookingData!['barberId'];
                    }

                    if (bookingData?['salonId'] != null) {
                      loyaltyPayload["salon_id"] = bookingData!['salonId'];
                      loyaltyPayload["type"] = "salon";
                    }

                    final res = await postLoyaltyBookingRxObj
                        .postLoyaltyBooking(data: loyaltyPayload)
                        .waitingForFutureWithoutBg();

                    if (res['status'] == 'success' || res['status'] == true) {
                      NavigationService.navigateTo(Routes.bookingSuccessScreen);
                    } else {
                      customToastMessage("Réservation échouée",
                          res['message'] ?? "Veuillez réessayer.");
                    }
                    return;
                  }

                  final payload = {
                    "date": formattedDate,
                    "customer_id": getProfileRxObj
                            .dataFetcher.valueOrNull?.data?.user?.id ??
                        9,
                    "salon_id": bookingData?['salonId'],
                    "barber_id": bookingData?['barberId'],
                    "payment_type": "online",
                    "booking_type": "online",
                    "request_type":
                        bookingData?['providerType'] ?? "home_barber",
                    "quantity": quantities,
                    "slot_id": bookingData?['slotId'] != null
                        ? [bookingData!['slotId']]
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
                      NavigationService.navigateTo(Routes.bookingSuccessScreen);
                    }
                  } else {
                    customToastMessage("Réservation échouée",
                        res['message'] ?? "Veuillez réessayer.");
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
}

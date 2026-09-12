import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tremley_cutomer/common_widgets/custom_button.dart';
import 'package:tremley_cutomer/constants/text_font_style.dart';
import 'package:tremley_cutomer/gen/assets.gen.dart';
import 'package:tremley_cutomer/gen/colors.gen.dart';
import 'package:tremley_cutomer/helpers/ui_helpers.dart';
import 'package:tremley_cutomer/helpers/navigation_service.dart';
import 'package:tremley_cutomer/helpers/all_routes.dart';
import 'package:tremley_cutomer/networks/api_acess.dart';
import 'package:tremley_cutomer/constants/app_constants.dart';
import 'package:tremley_cutomer/helpers/di.dart';
import 'package:tremley_cutomer/features/home/model/service_list_model.dart';
import 'package:intl/intl.dart';
import 'package:tremley_cutomer/common_widgets/custom_toast.dart';

class WaitingScreen extends StatefulWidget {
  final bool isASAP;
  final DateTime? selectedDate;
  final String? selectedTime;
  final Map<String, dynamic>? bookingData;

  const WaitingScreen({
    super.key,
    this.isASAP = true,
    this.selectedDate,
    this.selectedTime,
    this.bookingData,
  });

  @override
  State<WaitingScreen> createState() => _WaitingScreenState();
}

class _WaitingScreenState extends State<WaitingScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    _startNavigationTimer();
  }

  void _startNavigationTimer() {
    if (widget.isASAP) {
      _callAsapAPI();
    } else {
      _callSearchListAPI();
    }
  }

  Future<void> _callSearchListAPI() async {
    try {
      final bookingData = widget.bookingData ?? {};
      final double? lat = appData.read(kKeySelectedLat);
      final double? lng = appData.read(kKeySelectedLng);
      final String date = DateFormat('yyyy-MM-dd')
          .format(widget.selectedDate ?? DateTime.now());
      final String startTime = "11:00";
      final int consumeTime = bookingData['totalDuration'] ?? 60;

      final Map<String, dynamic> payload = {
        "latitude": lat ?? 23.8103,
        "longitude": lng ?? 90.4125,
        "date": date,
        "start_time": startTime,
        "consume_time": consumeTime,
      };

      final res =
          await postHomeBarberSearchListRxObj.postSearchList(data: payload);
      if (res && mounted) {
        final responseData =
            postHomeBarberSearchListRxObj.dataFetcher.valueOrNull;
        if (responseData != null &&
            responseData.data != null &&
            responseData.data!.isEmpty) {
          customToastMessage("Aucun résultat",
              "Aucun barbier trouvé à proximité pour l'instant.");
          NavigationService.goBackCall();
          return;
        }

        NavigationService.navigateToReplacementWithArgs(
            Routes.chooseBarberScreen, {
          'selectedDate': widget.selectedDate,
          'selectedTime': widget.selectedTime,
          'bookingData': widget.bookingData,
        });
      } else if (mounted) {
        NavigationService.goBackCall();
      }
    } catch (e) {
      if (mounted) {
        NavigationService.goBackCall();
      }
    }
  }

  Future<void> _callAsapAPI() async {
    try {
      final bookingData = widget.bookingData ?? {};
      final List<ServiceItem> services = bookingData['selectedServices'] ?? [];

      final String currentDate =
          DateFormat('yyyy-MM-dd').format(DateTime.now());
      final String startTime = DateFormat('HH:mm').format(DateTime.now());

      final List<int> serviceIds = [];
      final List<int> quantities = [];
      final List<double> prices = [];

      double subtotal = 0;
      double totalPrice = 0;
      for (var s in services) {
        if (s.quantity > 0) {
          serviceIds.add(s.id!);
          quantities.add(s.quantity);
          double p = double.tryParse(s.servicePrice?.price ?? '0') ?? 0;
          double discount =
              double.tryParse(s.servicePrice?.discount ?? '0') ?? 0;
          double finalPrice = p - discount;
          if (finalPrice < 0) finalPrice = 0;
          prices.add(finalPrice);
          subtotal += finalPrice * s.quantity;
          totalPrice += p * s.quantity;
        }
      }

      final payload = {
        "date": currentDate,
        "customer_id": appData.read(kKeyUserID),
        "payment_type": "online",
        "start_time": startTime,
        "service_id": serviceIds,
        "quantity": quantities,
        "price": prices,
        "subtotal": subtotal,
        "tax": 5,
        "total_price": totalPrice + 5
      };

      final res = await postAsapBookingRxObj.postBooking(data: payload);
      if (res && mounted) {
        NavigationService.navigateToReplacementWithArgs(
            Routes.bookingSuccessScreen, {
          'apiResponse': postAsapBookingRxObj.dataFetcher.value,
        });
      } else if (mounted) {
        NavigationService.goBackCall();
      }
    } catch (e) {
      if (mounted) {
        customToastMessage("Erreur", "Une erreur est survenue");
        NavigationService.goBackCall();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cFFFFFF,
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(),

            // Central Search Graphic with rotating loader
            _buildCentralGraphic(),

            UIHelper.verticalSpace(40.h),

            // Text Content
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.w),
              child: Text(
                  widget.isASAP
                      ? "Recherche d'un barbier disponible..."
                      : "Recherche de coiffeurs disponibles...",
                  textAlign: TextAlign.center,
                  style: TextFontStyle.textStyle22c222222InterTight600),
            ),

            UIHelper.verticalSpace(24.h),

            // Waiting Time Badge
            _buildTimeBadge(),

            const Spacer(),

            // Bottom Button
            Padding(
              padding: EdgeInsets.all(20.r),
              child: CustomButton(
                onPressed: () {
                  NavigationService.goBackCall();
                },
                title: "Annuler la demande",
                height: 56.h,
                backgroundColor: const Color(0xFFE0E0E0),
                foregroundColor: AppColors.c191919,
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCentralGraphic() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Rotated Golden Arc Loader
        SizedBox(
          width: 120.r,
          height: 120.r,
          child: CircularProgressIndicator(
            strokeWidth: 4.r,
            backgroundColor: AppColors.cF5F5F5,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.cB08D2A),
          ),
        ),

        // Inner Grey Solid Circle with Icon
        Container(
          padding: EdgeInsets.all(16.r),
          decoration: const BoxDecoration(
            color: AppColors.cF5F5F5,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Assets.icons.searchBarOutlinedBlack.image(
              width: 32.r,
              height: 32.r,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeBadge() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F6F6),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Assets.icons.clockOutlinedGrey.image(
            width: 18.r,
            height: 18.r,
            color: const Color(0xFF6C6C6C),
          ),
          UIHelper.horizontalSpace(8.w),
          Text(
            "Temps d'attente estimé : ~2 minutes",
            style: TextFontStyle.textStyle14c6C6C6CInterTight500.copyWith(
              fontSize: 14.sp,
            ),
          ),
        ],
      ),
    );
  }
}

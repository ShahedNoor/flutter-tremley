import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tremley_cutomer/common_widgets/custom_back_app_bar.dart';
import 'package:tremley_cutomer/common_widgets/custom_button.dart';
import 'package:tremley_cutomer/constants/text_font_style.dart';
import 'package:tremley_cutomer/gen/colors.gen.dart';
import 'package:tremley_cutomer/helpers/ui_helpers.dart';
import 'widgets/service_selection/service_selection_header.dart';
import 'widgets/service_selection/service_selection_list.dart';
import 'package:tremley_cutomer/helpers/all_routes.dart';
import 'package:tremley_cutomer/helpers/navigation_service.dart';
import 'package:tremley_cutomer/common_widgets/waiting_widget.dart';
import '../../model/service_list_model.dart';
import '../../model/barber_list_model.dart';
import '../../../../networks/api_acess.dart';

class ServiceSelectionScreen extends StatefulWidget {
  final int salonId;
  final String providerType; // Added providerType
  final String salonName;
  final double rating;
  final double distance;
  final String address;
  final bool isLoyalty;
  final int? loyaltyServiceId;
  final String? loyaltyServiceName;
  final String? loyaltyServiceDuration;

  const ServiceSelectionScreen({
    super.key,
    required this.salonId,
    this.providerType = "salon",
    required this.salonName,
    required this.rating,
    required this.distance,
    required this.address,
    this.isLoyalty = false,
    this.loyaltyServiceId,
    this.loyaltyServiceName,
    this.loyaltyServiceDuration,
  });

  @override
  State<ServiceSelectionScreen> createState() => _ServiceSelectionScreenState();
}

class _ServiceSelectionScreenState extends State<ServiceSelectionScreen> {
  Barber? _selectedBarber;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    getBarberListRxObj.fetchBarberList(widget.salonId);
    if (!widget.isLoyalty) {
      getSalonServiceListRxObj.fetchSalonServiceList(widget.salonId);
    }
  }

  Widget _buildMainContent(List<ServiceItem> services) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: UIHelper.kDefaulutPadding(),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ServiceSelectionHeader(
                  salonName: widget.salonName,
                  rating: widget.rating,
                  distance: widget.distance,
                  address: widget.address,
                  selectedBarber: _selectedBarber,
                  onBarberSelected: (val) =>
                      setState(() => _selectedBarber = val),
                  isLoyalty: widget.isLoyalty,
                ),
                UIHelper.verticalSpace(20.h),
                Text("Choisissez vos services",
                    style: TextFontStyle.textStyle20c1B1B1BInterTight600),
                UIHelper.verticalSpace(16.h),
                ServiceSelectionList(
                  services: services,
                  selectedIndex: _selectedIndex,
                  onServiceSelected: (index) =>
                      setState(() => _selectedIndex = index),
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
                onPressed: () {
                  final service = services[_selectedIndex];
                  final price = service.servicePrice?.price ?? '0';
                  final discount = service.servicePrice?.discount;
                  final double priceVal = double.tryParse(price) ?? 0;
                  final double discountVal =
                      double.tryParse(discount ?? '0') ?? 0;
                  final double finalPrice = priceVal - discountVal;

                  final Map<String, dynamic> bookingData = {
                    "salonId": widget.salonId,
                    "providerType": widget.providerType,
                    "serviceId": service.id,
                    "barberId": _selectedBarber?.id,
                    "totalPrice": widget.isLoyalty ? 0.0 : finalPrice,
                  };

                  NavigationService.navigateToWithObject(
                    Routes.bookingScheduleScreen,
                    {
                      "salonId": widget.salonId,
                      "providerType": widget.providerType,
                      "salonName": widget.salonName,
                      "serviceName": service.serviceName ?? '',
                      "duration":
                          "${service.servicePrice?.timeDuration ?? '30'} min",
                      "price": widget.isLoyalty
                          ? "0 €"
                          : "${finalPrice % 1 == 0 ? finalPrice.toInt() : finalPrice.toStringAsFixed(2)} €",
                      "barberId": _selectedBarber?.id,
                      "barberName": _selectedBarber?.name ?? "Automatique",
                      "barberImage": _selectedBarber?.profileImage ?? "",
                      "barberRating": 4.9,
                      "bookingData": bookingData,
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
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isLoyalty) {
      final mockServices = [
        ServiceItem(
          id: widget.loyaltyServiceId,
          serviceName: widget.loyaltyServiceName,
          salonId: widget.salonId,
          servicePrice: ServicePrice(
            price: "0",
            discount: "0",
            timeDuration:
                widget.loyaltyServiceDuration ?? "30", // Fallback duration
            createdForType: widget.providerType,
            createdBy: widget.salonId,
          ),
        )
      ];
      return Scaffold(
        backgroundColor: AppColors.cFFFFFF,
        appBar: const CustomBackAppBar(title: "Services"),
        body: _buildMainContent(mockServices),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.cFFFFFF,
      appBar: const CustomBackAppBar(title: "Services"),
      body: StreamBuilder<ServiceListModel>(
          stream: getSalonServiceListRxObj.dataStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: WaitingWidget());
            }

            if (!snapshot.hasData || (snapshot.data?.data.isEmpty ?? true)) {
              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: UIHelper.kDefaulutPadding(),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ServiceSelectionHeader(
                      salonName: widget.salonName,
                      rating: widget.rating,
                      distance: widget.distance,
                      address: widget.address,
                      selectedBarber: _selectedBarber,
                      onBarberSelected: (val) =>
                          setState(() => _selectedBarber = val),
                    ),
                    UIHelper.verticalSpace(20.h),
                    Text("Choisissez vos services",
                        style: TextFontStyle.textStyle20c1B1B1BInterTight600),
                    UIHelper.verticalSpace(40.h),
                    Center(
                      child: Text(
                        "Aucun service trouvé",
                        style: TextFontStyle.textStyle16c191919Inter600,
                      ),
                    ),
                  ],
                ),
              );
            }

            return _buildMainContent(snapshot.data!.data);
          }),
    );
  }
}

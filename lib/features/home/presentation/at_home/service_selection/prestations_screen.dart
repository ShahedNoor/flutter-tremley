import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tremley_cutomer/common_widgets/custom_back_app_bar.dart';
import 'package:tremley_cutomer/common_widgets/custom_button.dart';
import 'package:tremley_cutomer/common_widgets/custom_toast.dart';
import 'package:tremley_cutomer/common_widgets/not_found_widget.dart';
import 'package:tremley_cutomer/common_widgets/waiting_widget.dart';
import 'package:tremley_cutomer/constants/text_font_style.dart';
import 'package:tremley_cutomer/features/home/model/service_list_model.dart';
import 'package:tremley_cutomer/gen/colors.gen.dart';
import 'package:tremley_cutomer/helpers/all_routes.dart';
import 'package:tremley_cutomer/helpers/navigation_service.dart';
import 'package:tremley_cutomer/helpers/ui_helpers.dart';
import 'package:tremley_cutomer/networks/api_acess.dart';

class PrestationsScreen extends StatefulWidget {
  final bool isLoyalty;
  final int? loyaltyServiceId;
  final String? loyaltyServiceName;
  final String? loyaltyServiceDuration;
  final int? barberId;
  final String? barberName;
  final String? barberImage;

  const PrestationsScreen({
    super.key,
    this.isLoyalty = false,
    this.loyaltyServiceId,
    this.loyaltyServiceName,
    this.loyaltyServiceDuration,
    this.barberId,
    this.barberName,
    this.barberImage,
  });

  @override
  State<PrestationsScreen> createState() => _PrestationsScreenState();
}

class _PrestationsScreenState extends State<PrestationsScreen> {
  /// Local mutable list with quantity tracking per item
  List<ServiceItem> _services = [];

  @override
  void initState() {
    super.initState();
    if (widget.isLoyalty) {
      _services = [
        ServiceItem(
          id: widget.loyaltyServiceId,
          serviceName: widget.loyaltyServiceName,
          salonId: null,
          servicePrice: ServicePrice(
            price: "0",
            discount: "0",
            timeDuration: widget.loyaltyServiceDuration ?? "30",
            createdForType: "home_barber",
            createdBy: widget.barberId,
          ),
          quantity: 1, // Pre-select
        )
      ];
    } else {
      getCustomerServiceListRxObj.fetchCustomerServiceList();
    }
  }

  double get _totalPrice {
    double total = 0;
    for (final service in _services) {
      final double price =
          double.tryParse(service.servicePrice?.price ?? '0') ?? 0;
      final double discount =
          double.tryParse(service.servicePrice?.discount ?? '0') ?? 0;
      final double finalPrice = price - discount;
      total += finalPrice * service.quantity;
    }
    return total;
  }

  int get _totalPersonnes {
    int total = 0;
    for (final service in _services) {
      total += service.quantity;
    }
    return total;
  }

  int get _totalDuration {
    int total = 0;
    for (final service in _services) {
      if (service.quantity > 0) {
        final durationStr = service.servicePrice?.timeDuration ?? '0';
        final int duration = int.tryParse(durationStr) ?? 0;
        total += duration * service.quantity;
      }
    }
    return total;
  }

  String _formatDuration(String? minutes) {
    if (minutes == null || minutes.isEmpty) return '';
    final int? mins = int.tryParse(minutes);
    if (mins == null) return '$minutes min';
    if (mins >= 60) {
      final int h = mins ~/ 60;
      final int m = mins % 60;
      return m == 0 ? '${h}h' : '${h}h ${m}min';
    }
    return '$mins min';
  }

  Widget _buildMainContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Text(
            "Choisissez vos services",
            style: TextFontStyle.textStyle20c222222InterTight600,
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            itemCount: _services.length,
            itemBuilder: (context, index) {
              return _buildServiceCard(index, _services[index]);
            },
          ),
        ),
        _buildBottomSummary(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cFFFFFF,
      appBar: CustomBackAppBar(
        title: "Prestations",
        onBack: () => NavigationService.goBackCall(),
      ),
      body: widget.isLoyalty
          ? _buildMainContent()
          : StreamBuilder<ServiceListModel>(
              stream: getCustomerServiceListRxObj.dataStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const NotFoundWidget();
                }

                if (!snapshot.hasData || snapshot.data == null) {
                  return const Center(child: WaitingWidget());
                }

                final List<ServiceItem> apiServices = snapshot.data!.data;

                if (apiServices.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const NotFoundWidget(),
                        UIHelper.verticalSpace(16.h),
                        Text(
                          "Aucun service trouvé",
                          style: TextFontStyle.textStyle16c222222InterTight600,
                        ),
                      ],
                    ),
                  );
                }

                if (_services.length != apiServices.length) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    setState(() {
                      _services = apiServices
                          .map((s) => ServiceItem(
                                id: s.id,
                                serviceName: s.serviceName,
                                salonId: s.salonId,
                                servicePrice: s.servicePrice,
                                quantity: 0,
                              ))
                          .toList();
                    });
                  });
                  return const Center(child: WaitingWidget());
                }

                return _buildMainContent();
              },
            ),
    );
  }

  Widget _buildServiceCard(int index, ServiceItem service) {
    final String duration = _formatDuration(service.servicePrice?.timeDuration);
    final String price = service.servicePrice?.price ?? '0';
    final String? discount = service.servicePrice?.discount;
    final double priceVal = double.tryParse(price) ?? 0;
    final double discountVal = double.tryParse(discount ?? '0') ?? 0;
    final double finalPrice = priceVal - discountVal;

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.cFFFFFF,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.cEEEEEE),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  service.serviceName ?? '',
                  style: TextFontStyle.textStyle16c222222InterTight600,
                ),
                UIHelper.verticalSpace(4.h),
                if (duration.isNotEmpty)
                  Text(
                    duration,
                    style: TextFontStyle.textStyle14c9B9B9BInterTight400,
                  ),
                UIHelper.verticalSpace(8.h),
                Row(
                  children: [
                    Text(
                      "${finalPrice % 1 == 0 ? finalPrice.toInt() : finalPrice.toStringAsFixed(2)} €",
                      style: TextFontStyle.textStyle16c222222InterTight600,
                    ),
                    if (discountVal > 0) ...[
                      UIHelper.horizontalSpace(8.w),
                      Text(
                        "${priceVal % 1 == 0 ? priceVal.toInt() : priceVal.toStringAsFixed(2)} €",
                        style: TextFontStyle.textStyle14c9B9B9BInterTight400
                            .copyWith(
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          if (!widget.isLoyalty)
            _buildQuantitySelector(index, service.quantity),
        ],
      ),
    );
  }

  Widget _buildQuantitySelector(int index, int quantity) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: AppColors.cF2F2F2,
        borderRadius: BorderRadius.circular(100.r),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: quantity > 0
                ? () {
                    setState(() {
                      _services[index].quantity--;
                    });
                  }
                : null,
            child: Container(
              padding: EdgeInsets.all(8.r),
              child: Icon(
                Icons.remove,
                size: 16.sp,
                color: quantity == 0 ? AppColors.cC6C6C6 : AppColors.c191919,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Text(
              "$quantity",
              style: TextFontStyle.textStyle16c191919InterTight600,
            ),
          ),
          _buildCircleButton(
            icon: Icons.add,
            onTap: () {
              setState(() {
                _services[index].quantity++;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCircleButton({required IconData icon, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(8.r),
        decoration: const BoxDecoration(
          color: AppColors.cFFFFFF,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 16.sp,
          color: onTap == null ? AppColors.cC6C6C6 : AppColors.c191919,
        ),
      ),
    );
  }

  Widget _buildBottomSummary() {
    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: AppColors.cFFFFFF,
        border: Border(
          top: BorderSide(color: AppColors.cEEEEEE, width: 1.h),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total",
                  style: TextFontStyle.textStyle16c9B9B9BInterTight400.copyWith(
                    fontSize: 18.sp,
                  ),
                ),
                Text(
                  "${_totalPrice % 1 == 0 ? _totalPrice.toInt() : _totalPrice.toStringAsFixed(2)}€",
                  style: TextFontStyle.textStyle16c191919InterTight600.copyWith(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            UIHelper.verticalSpace(20.h),
            CustomButton(
              onPressed: () {
                if (_totalPersonnes == 0) {
                  customToastMessage("Le panier est vide.",
                      'Veuillez sélectionner au moins un service');
                  return;
                }

                // Get salonId and providerType from the first selected service
                int? selectedSalonId;
                String providerType = "salon";
                for (var s in _services) {
                  if (s.quantity > 0) {
                    selectedSalonId = s.salonId ?? s.servicePrice?.createdBy;
                    providerType = s.servicePrice?.createdForType ?? "salon";
                    break;
                  }
                }

                final selectedServices =
                    _services.where((s) => s.quantity > 0).toList();

                final Map<String, dynamic> bookingData = {
                  "salonId":
                      providerType == 'home_barber' ? null : selectedSalonId,
                  "providerType": providerType,
                  "selectedServices": selectedServices,
                  "totalPrice": _totalPrice,
                  "totalDuration": _totalDuration,
                  "isLoyalty": widget.isLoyalty,
                  "loyaltyServiceId": widget.loyaltyServiceId,
                  "barberName": widget.barberName,
                  "barberImage": widget.barberImage,
                };

                NavigationService.navigateToWithArgs(Routes.chooseTimeScreen, {
                  "salonId": selectedSalonId,
                  "providerType": providerType,
                  "bookingData": bookingData,
                });
              },
              title: "Continuer",
              height: 55.h,
            ),
            UIHelper.verticalSpace(10.h),
          ],
        ),
      ),
    );
  }
}

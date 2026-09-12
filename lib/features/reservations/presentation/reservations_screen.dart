import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../constants/text_font_style.dart';
import '../../../gen/colors.gen.dart';
import '../../../helpers/ui_helpers.dart';
import '../../../helpers/navigation_service.dart';
import '../../../helpers/all_routes.dart';
import '../../../networks/api_acess.dart';
import '../model/reservation_model.dart';
import 'widgets/reservation_card.dart';
import 'widgets/shimmers/reservation_shimmer.dart';
import '../../../common_widgets/no_data_widget.dart';
import '../../../helpers/location_service.dart';

class ReservationsScreen extends StatefulWidget {
  const ReservationsScreen({super.key});

  @override
  State<ReservationsScreen> createState() => ReservationsScreenState();
}

class ReservationsScreenState extends State<ReservationsScreen> {
  static ReservationsScreenState? instance;
  int _activeTab = 0;
  final List<String> _tabs = ["En cours", "À venir", "Passées", "Annulées"];

  @override
  void initState() {
    super.initState();
    instance = this;
    fetchData();
  }

  @override
  void dispose() {
    if (instance == this) {
      instance = null;
    }
    super.dispose();
  }

  Future<void> fetchData({bool clean = true}) async {
    String type = "";
    if (_activeTab == 0) type = "";
    if (_activeTab == 1) type = "upcoming";
    if (_activeTab == 2) type = "past";
    if (_activeTab == 3) type = "cancelled";

    if (clean) {
      getReservationsRxObj.clean();
    }
    try {
      await getReservationsRxObj.fetchReservations(type);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cFFFFFF,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              UIHelper.verticalSpace(20.h),
              Text(
                "Réservations",
                style: TextFontStyle.textStyle28c000000InterTight500.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 26.sp,
                ),
              ),
              UIHelper.verticalSpace(24.h),
              _buildTabBar(),
              UIHelper.verticalSpace(24.h),
              Expanded(
                child: _buildReservationList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      height: 50.h,
      decoration: BoxDecoration(
        color: AppColors.cF2F2F2,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: List.generate(_tabs.length, (index) {
          bool isActive = _activeTab == index;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                if (_activeTab != index) {
                  setState(() => _activeTab = index);
                  fetchData();
                }
              },
              child: Container(
                margin: EdgeInsets.all(4.r),
                decoration: BoxDecoration(
                  color: isActive ? AppColors.cFFFFFF : Colors.transparent,
                  borderRadius: BorderRadius.circular(10.r),
                  boxShadow: isActive
                      ? [
                          BoxShadow(
                            color: AppColors.c000000.withValues(alpha: 0.04),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : [],
                ),
                alignment: Alignment.center,
                child: Text(
                  _tabs[index],
                  style: TextFontStyle.textStyle14c4D4D4DInterTight500.copyWith(
                    color: isActive ? AppColors.c191919 : AppColors.c737373,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildReservationList() {
    return RefreshIndicator(
      color: AppColors.allPrimaryColor,
      backgroundColor: AppColors.cFFFFFF,
      onRefresh: () => fetchData(clean: false),
      child: StreamBuilder<ReservationModel>(
        stream: getReservationsRxObj.getReservationStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const ReservationShimmer();
          }

          if (snapshot.hasError) {
            return Center(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: NoInternetWidget(
                  onRetry: () => fetchData(),
                ),
              ),
            );
          }

          if (snapshot.hasData && snapshot.data != null) {
            // If status is null, it means clean() was called and we are waiting for API
            if (snapshot.data!.status == null) {
              return const ReservationShimmer();
            }

            final data = snapshot.data!.data;
            if (data == null || data.isEmpty) {
              return Center(
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: const NoDataWidget(
                    title: "Aucune réservation",
                    subtitle: "Vous n'avez aucune réservation pour le moment.",
                  ),
                ),
              );
            }

            return ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: data.length,
              itemBuilder: (context, index) {
              final item = data[index];

              // Parse color based on status if needed
              Color statusColor = UIHelper.getStatusColor(item.status ?? "");

              bool isSalon =
                  item.locationType?.toLowerCase().contains('salon') ?? false;

              String displayDate = item.dateTime ?? "";
              if (displayDate.toLowerCase().contains("today")) {
                displayDate = displayDate.replaceAll(
                    RegExp(r'today', caseSensitive: false), "Aujourd'hui");
              }

              double lat = double.tryParse(item.locationLat ?? "0") ?? 0.0;
              double lng = double.tryParse(item.locationLon ?? "0") ?? 0.0;

              return FutureBuilder<String?>(
                future: (lat != 0.0 && lng != 0.0)
                    ? LocationService.instance
                        .getLocationNameFromCoordinates(lat, lng)
                    : Future.value(null),
                builder: (context, snapshot) {
                  String displayLocation =
                      snapshot.data ?? item.locationName ?? "N/A";
                  if (displayLocation.toLowerCase().contains("at home")) {
                    displayLocation = displayLocation.replaceAll(
                        RegExp(r'at home', caseSensitive: false), "À domicile");
                  }

                  return ReservationCard(
                    serviceName: item.serviceName ?? "",
                    status: UIHelper.translateStatus(item.status ?? ""),
                    statusColor: statusColor,
                    statusBgColor: UIHelper.getStatusBgColor(item.status ?? ""),
                    isAtSalon: isSalon,
                    location: displayLocation,
                    date: displayDate,
                    buttonText: isSalon ? "Détails" : "Suivre le barbier",
                    onTap: () {
                      bool isCompleted =
                          _activeTab == 2; // 2 is Past (Completed)
                      if (_activeTab == 0 || _activeTab == 1) {
                        // En cours or Upcoming
                        if (isSalon) {
                          NavigationService.navigateToWithArgs(
                            Routes.bookingDetailsScreen,
                            {'id': item.id, 'isCompleted': false},
                          );
                        } else {
                          NavigationService.navigateToWithArgs(
                            Routes.barberBookingTrackingScreen,
                            {'id': item.id},
                          );
                        }
                      } else {
                        // Past or Cancelled
                        if (isSalon) {
                          NavigationService.navigateToWithArgs(
                            Routes.bookingDetailsScreen,
                            {'id': item.id, 'isCompleted': isCompleted},
                          );
                        } else {
                          NavigationService.navigateToWithArgs(
                            Routes.bookingReviewScreen,
                            {
                              'id': item.id,
                              'isCompleted': isCompleted,
                              'initialIsRated': false
                            },
                          );
                        }
                      }
                    },
                  );
                },
              );
            },
          );
        }
        return const ReservationShimmer();
      },
    ),
  );
}
}

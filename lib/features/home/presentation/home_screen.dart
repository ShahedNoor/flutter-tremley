import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../gen/colors.gen.dart';
import '../../../../helpers/ui_helpers.dart';
import '../../../../helpers/di.dart';
import '../../../../helpers/location_service.dart';
import 'at_home/home_at_home_view.dart';
import 'widgets/home_custom_tabs.dart';
import 'widgets/home_header.dart';
import 'at_salon/widgets/home_salon_list_view.dart';
import 'package:tremley_cutomer/features/home/model/salon_or_barber_model.dart';
import 'shimmers/home_salon_list_shimmer.dart';
import 'package:tremley_cutomer/constants/app_constants.dart';
import 'package:tremley_cutomer/constants/text_font_style.dart';
import '../../../../common_widgets/notification_warning_banner.dart';
import 'at_salon/widgets/home_search_and_filter.dart';
import '../data/rx_get_salon_or_barber/rx.dart';

import '../../../../networks/api_acess.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  StreamSubscription? _locationSub;

  @override
  void initState() {
    super.initState();
    getProfileRxObj.fetchProfile();
    _loadSalonsFromStoredLocation();
    _locationSub = LocationService.instance.locationStream.listen((_) {
      if (mounted) {
        _loadSalonsFromStoredLocation();
      }
    });
  }

  @override
  void dispose() {
    _locationSub?.cancel();
    super.dispose();
  }

  int _selectedTab = 0; // 0 for "RDV au salon", 1 for "À domicile"

  void _loadSalonsFromStoredLocation() {
    final double? lat = appData.read(kKeySelectedLat);
    final double? lng = appData.read(kKeySelectedLng);

    if (lat != null && lng != null) {
      getSalonOrBarberRxObj.fetchSalonOrBarbers(
        latitude: lat,
        longitude: lng,
        type: "salon",
      );
      getRecentSalonOrBarberRxObj.fetchRecentSalonOrBarbers(
        latitude: lat,
        longitude: lng,
        type: "salon",
        perPage: 15,
      );
    }
  }

  Future<void> _handleRefresh() async {
    getProfileRxObj.fetchProfile();
    final double? lat = appData.read(kKeySelectedLat);
    final double? lng = appData.read(kKeySelectedLng);

    if (lat != null && lng != null) {
      await Future.wait([
        getSalonOrBarberRxObj.fetchSalonOrBarbers(
          latitude: lat,
          longitude: lng,
          type: "salon",
        ),
        getRecentSalonOrBarberRxObj.fetchRecentSalonOrBarbers(
          latitude: lat,
          longitude: lng,
          type: "salon",
          perPage: 15,
        ),
      ]);
    }
  }

  Widget _buildContent() {
    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            children: [
              UIHelper.verticalSpace(16.h),
              const HomeHeader(),
              const NotificationWarningBanner(),
              UIHelper.verticalSpace(14.h),
            ],
          ),
        ),
        SliverPersistentHeader(
          pinned: true,
          delegate: _SliverTabDelegate(
            child: Container(
              color: AppColors.cFFFFFF,
              alignment: Alignment.topCenter,
              padding: EdgeInsets.only(top: 8.h),
              child: HomeCustomTabs(
                selectedTab: _selectedTab,
                onTabChanged: (index) => setState(() => _selectedTab = index),
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: _selectedTab == 0
              ? Column(
                  children: [
                    UIHelper.verticalSpace(8.h),
                    const HomeSearchAndFilter(),
                    UIHelper.verticalSpace(12.h),
                    // const HomeLocationButton(),
                    // UIHelper.verticalSpace(12.h),
                    StreamBuilder<SalonOrBarberModel?>(
                      stream: getRecentSalonOrBarberRxObj.dataStream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData && snapshot.data != null) {
                          final list = snapshot.data!.data?.list ?? [];
                          if (list.isEmpty) {
                            return const SizedBox.shrink();
                          }
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20.w),
                                child: Text(
                                  "Réserver à nouveau",
                                  style: TextFontStyle
                                      .textStyle20c191919Inter600
                                      .copyWith(fontSize: 18.sp),
                                ),
                              ),
                              UIHelper.verticalSpace(12.h),
                              HomeSalonListView(salons: list),
                            ],
                          );
                        } else if (snapshot.hasError) {
                          return const SizedBox.shrink();
                        }

                        // Loading state
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.w),
                              child: Text(
                                "Réserver à nouveau",
                                style: TextFontStyle.textStyle20c191919Inter600
                                    .copyWith(fontSize: 18.sp),
                              ),
                            ),
                            UIHelper.verticalSpace(12.h),
                            const HomeSalonListShimmer(),
                          ],
                        );
                      },
                    ),
                    UIHelper.verticalSpace(24.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Barbiers à proximité",
                          style: TextFontStyle.textStyle20c191919Inter600
                              .copyWith(fontSize: 18.sp),
                        ),
                      ),
                    ),
                    UIHelper.verticalSpace(12.h),
                    StreamBuilder<SalonOrBarberModel?>(
                      stream: getSalonOrBarberRxObj.dataStream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData && snapshot.data != null) {
                          final list = snapshot.data!.data?.list ?? [];
                          if (list.isEmpty) {
                            return SizedBox(
                              height: 200.h,
                              child: const Center(
                                child: Text("Aucun salon disponible"),
                              ),
                            );
                          }
                          return HomeSalonListView(salons: list);
                        } else if (snapshot.hasError) {
                          return SizedBox(
                            height: 200.h,
                            child: const Center(
                              child: Text(
                                  "Une erreur est survenue lors du chargement des salons."),
                            ),
                          );
                        }

                        if (getSalonOrBarberRxObj.loadingState.value ==
                            HomeLoadingState.filter) {
                          return const HomeSalonListShimmer();
                        }
                        return const HomeSalonListShimmer();
                      },
                    ),
                  ],
                )
              : const HomeAtHomeView(),
        ),
        SliverToBoxAdapter(
          child: UIHelper.verticalSpace(20.h),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cFFFFFF,
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.allPrimaryColor,
          backgroundColor: AppColors.cFFFFFF,
          onRefresh: _handleRefresh,
          child: _buildContent(),
        ),
      ),
    );
  }
}

// Custom Delegate for Pinned Tab Bar
class _SliverTabDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _SliverTabDelegate({required this.child});

  @override
  double get minExtent => 48.h.roundToDouble();
  @override
  double get maxExtent => 48.h.roundToDouble();

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  bool shouldRebuild(_SliverTabDelegate oldDelegate) {
    return true;
  }
}

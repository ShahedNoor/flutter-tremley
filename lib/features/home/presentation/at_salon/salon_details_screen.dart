import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tremley_cutomer/common_widgets/custom_button.dart';
import 'package:tremley_cutomer/gen/colors.gen.dart';
import 'package:tremley_cutomer/helpers/ui_helpers.dart';
import 'widgets/salon_details/salon_details_image_header.dart';
import 'widgets/salon_details/salon_details_info_section.dart';
import 'widgets/salon_details/salon_details_reviews_section.dart';
import 'package:tremley_cutomer/helpers/all_routes.dart';
import 'package:tremley_cutomer/helpers/navigation_service.dart';
import 'package:tremley_cutomer/features/home/model/salon_or_barber_model.dart';
import 'package:tremley_cutomer/networks/api_acess.dart';
import '../shimmers/salon_reviews_shimmer.dart';

class SalonDetailsScreen extends StatefulWidget {
  final SalonOrBarber salon;

  const SalonDetailsScreen({
    super.key,
    required this.salon,
  });

  @override
  State<SalonDetailsScreen> createState() => _SalonDetailsScreenState();
}

class _SalonDetailsScreenState extends State<SalonDetailsScreen> {
  int _perPage = 2;
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    if (widget.salon.id != null) {
      getSalonReviewsRxObj.fetchSalonReviews(widget.salon.id!, _perPage);
    }
  }

  String _formatTime(String? time) {
    if (time == null || time.isEmpty) return "";
    final parts = time.split(':');
    if (parts.length >= 2) {
      return "${parts[0]}h${parts[1]}";
    }
    return time;
  }

  @override
  Widget build(BuildContext context) {
    final double distanceVal = widget.salon.distanceKm ?? 0.0;

    final String name = widget.salon.name ?? "";
    final double rating =
        double.tryParse(widget.salon.avgRating?.toString() ?? '0') ?? 5.0;
    final String address = widget.salon.salonAddress ?? "";
    final String openingTime = _formatTime(widget.salon.openTime);
    final String closingTime = _formatTime(widget.salon.closeTime);
    final int barbersCount = widget.salon.barberCount ?? 0;
    final String description =
        widget.salon.about ?? "Aucune description disponible.";

    return Scaffold(
      backgroundColor: AppColors.cFFFFFF,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SalonDetailsImageHeader(salon: widget.salon),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        UIHelper.verticalSpace(20.h),
                        SalonDetailsInfoSection(
                          name: name,
                          rating: rating,
                          address: address,
                          distance: distanceVal,
                          openingTime: openingTime,
                          closingTime: closingTime,
                          barbersCount: barbersCount,
                          description: description,
                        ),
                        UIHelper.verticalSpace(24.h),
                        StreamBuilder(
                          stream: getSalonReviewsRxObj.fileData,
                          builder: (context, snapshot) {
                            if (snapshot.hasData &&
                                snapshot.data != null &&
                                snapshot.data!.status == true) {
                              final model = snapshot.data!;
                              final list = model.data?.list ?? [];

                              final List<Map<String, dynamic>> apiReviews = list
                                  .map((r) => {
                                        "profilePic": r.customerImage ?? "",
                                        "name": r.customerName ?? "Utilisateur",
                                        "text": r.review ?? "",
                                      })
                                  .toList();

                              return SalonDetailsReviewsSection(
                                rating: rating,
                                reviewCount: model.data?.pagination?.total ?? 0,
                                reviews: apiReviews,
                                hasMore: (model.data?.pagination?.total ?? 0) >
                                        apiReviews.length ||
                                    model.data?.pagination?.nextPage != null,
                                isLoadingMore: _isLoadingMore,
                                onLoadMore: () async {
                                  setState(() {
                                    _perPage += 2;
                                    _isLoadingMore = true;
                                  });
                                  await getSalonReviewsRxObj.fetchSalonReviews(
                                      widget.salon.id!, _perPage);
                                  setState(() {
                                    _isLoadingMore = false;
                                  });
                                },
                              );
                            } else if (snapshot.hasError) {
                              return SalonDetailsReviewsSection(
                                rating: rating,
                                reviewCount: 0,
                                reviews: const [],
                                hasMore: false,
                              );
                            }
                            return const SalonReviewsSectionShimmer();
                          },
                        ),
                        UIHelper.verticalSpace(20.h),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 16.h),
              child: CustomButton(
                onPressed: () {
                  NavigationService.navigateToWithObject(
                    Routes.serviceSelectionScreen,
                    {
                      "salonId": widget.salon.id,
                      "providerType": widget.salon.role ?? "salon",
                      "salonName": name,
                      "rating": rating,
                      "distance": distanceVal,
                      "address": address,
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
        ],
      ),
    );
  }
}

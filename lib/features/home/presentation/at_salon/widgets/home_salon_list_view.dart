import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'home_salon_card.dart';
import 'package:tremley_cutomer/features/home/model/salon_or_barber_model.dart';
import 'package:tremley_cutomer/helpers/all_routes.dart';
import 'package:tremley_cutomer/helpers/navigation_service.dart';

class HomeSalonListView extends StatelessWidget {
  final List<SalonOrBarber> salons;

  const HomeSalonListView({
    super.key,
    required this.salons,
  });

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
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10.w,
          mainAxisSpacing: 15.h,
          childAspectRatio: 0.75, // Aspect ratio to fit the card contents
        ),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: salons.length,
        itemBuilder: (context, index) {
          final salon = salons[index];

          final String distanceStr = salon.distanceKm != null
              ? "${salon.distanceKm!.toStringAsFixed(2)} km"
              : "0 km";

          return HomeSalonCard(
            name: salon.name ?? "",
            rating: double.tryParse(salon.avgRating?.toString() ?? '0') ?? 0.0,
            reviewCount: salon.reviewCount ?? 0,
            distance: distanceStr,
            address: salon.salonAddress ?? "",
            status: salon.isOpenNow == true ? "Ouvert" : "Fermé",
            closingTime: _formatTime(salon.closeTime),
            imageUrl: salon.profileImage ?? "",
            onTap: () {
              NavigationService.navigateToWithObject(
                Routes.salonDetailsScreen,
                salon,
              );
            },
          );
        },
      ),
    );
  }
}

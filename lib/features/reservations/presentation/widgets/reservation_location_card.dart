import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmaps;
import 'package:apple_maps_flutter/apple_maps_flutter.dart' as amaps;
import '../../../../gen/assets.gen.dart';
import '../../../../gen/colors.gen.dart';
import '../../../../helpers/map_helper.dart';
import '../../../../helpers/ui_helpers.dart';
import '../../../../constants/text_font_style.dart';
import '../../../../helpers/location_service.dart';

class ReservationLocationCard extends StatelessWidget {
  final String address;
  final String? lat;
  final String? lng;
  const ReservationLocationCard(
      {super.key, required this.address, this.lat, this.lng});

  @override
  Widget build(BuildContext context) {
    double latitude = double.tryParse(lat ?? '') ?? 48.8566;
    double longitude = double.tryParse(lng ?? '') ?? 2.3522;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.cF9F9F9,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
            child: MapHelper.getMapView(
              height: 180.h,
              latitude: latitude,
              longitude: longitude,
              googleMarkers: {
                gmaps.Marker(
                  markerId: const gmaps.MarkerId('reservation_location'),
                  position: gmaps.LatLng(latitude, longitude),
                ),
              },
              appleAnnotations: {
                amaps.Annotation(
                  annotationId: amaps.AnnotationId('reservation_location'),
                  position: amaps.LatLng(latitude, longitude),
                ),
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                Assets.icons.sendOutlinedBlack.image(
                  width: 24.w,
                  height: 24.w,
                ),
                UIHelper.horizontalSpace(12.w),
                Expanded(
                  child: FutureBuilder<String?>(
                    future: (latitude != 0.0 && longitude != 0.0)
                        ? LocationService.instance.getLocationNameFromCoordinates(latitude, longitude)
                        : Future.value(null),
                    builder: (context, snapshot) {
                      String displayAddress = address;
                      if (snapshot.hasData && snapshot.data != null) {
                        displayAddress = snapshot.data!;
                      } else if ((address == "N/A" || address.isEmpty) && lat != null && lng != null) {
                        displayAddress = "$lat, $lng";
                      }
                      
                      return Text(
                        displayAddress,
                        style: TextFontStyle.textStyle16c191919InterTight600.copyWith(
                          fontSize: 15.sp,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

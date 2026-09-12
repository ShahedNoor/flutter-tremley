import 'dart:async';
import 'dart:io';
import 'dart:developer' as dev;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dio/dio.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmaps;
import 'package:apple_maps_flutter/apple_maps_flutter.dart' as amaps;
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

import 'package:tremley_cutomer/common_widgets/custom_button.dart';
import 'package:tremley_cutomer/common_widgets/custom_textform_field.dart';
import 'package:tremley_cutomer/constants/text_font_style.dart';
import 'package:tremley_cutomer/gen/assets.gen.dart';
import 'package:tremley_cutomer/gen/colors.gen.dart';
import 'package:tremley_cutomer/helpers/all_routes.dart';
import 'package:tremley_cutomer/helpers/navigation_service.dart';
import 'package:tremley_cutomer/helpers/ui_helpers.dart';
import 'package:tremley_cutomer/helpers/map_helper.dart';
import 'package:tremley_cutomer/helpers/di.dart';
import 'package:tremley_cutomer/constants/app_constants.dart';

import '../../../../common_widgets/waiting_widget.dart';

class HomeAtHomeView extends StatefulWidget {
  const HomeAtHomeView({super.key});

  @override
  State<HomeAtHomeView> createState() => _HomeAtHomeViewState();
}

class _HomeAtHomeViewState extends State<HomeAtHomeView> {
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  double _latitude = 48.8566; // default Paris
  double _longitude = 2.3522;
  String _address = "Paris, France";

  List<Map<String, dynamic>> _suggestions = [];
  bool _isSearching = false;
  Timer? _debounceTimer;

  gmaps.GoogleMapController? _googleMapController;
  amaps.AppleMapController? _appleMapController;

  @override
  void initState() {
    super.initState();
    _loadCurrentLocation();
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _loadCurrentLocation() {
    final double? savedLat = appData.read(kKeySelectedLat);
    final double? savedLong = appData.read(kKeySelectedLng);
    final String? savedLocation = appData.read(kKeySelectedLocation);

    if (savedLat != null && savedLong != null) {
      setState(() {
        _latitude = savedLat;
        _longitude = savedLong;
        if (savedLocation != null && savedLocation.isNotEmpty) {
          _address = savedLocation;
        }
      });
    }
  }

  void _onSearchChanged(String query) {
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      if (query.isNotEmpty) {
        _fetchSuggestions(query);
      } else {
        setState(() {
          _suggestions = [];
        });
      }
    });
  }

  Future<void> _fetchSuggestions(String query) async {
    setState(() {
      _isSearching = true;
    });

    // Try Google Places AutoComplete API first
    try {
      final dio = Dio();
      final url =
          "https://maps.googleapis.com/maps/api/place/autocomplete/json";
      final response = await dio.get(url, queryParameters: {
        "input": query,
        "key": kGoogleMapsApiKey,
        "language": "fr",
      });

      if (response.data["status"] == "OK") {
        final predictions = response.data["predictions"] as List;
        setState(() {
          _suggestions = predictions
              .map((p) => {
                    "description": p["description"] as String,
                    "place_id": p["place_id"] as String,
                  })
              .toList();
          _isSearching = false;
        });
        return;
      }
    } catch (e) {
      dev.log("Google Places autocomplete error: $e");
    }

    // Fallback using native geocoding:
    try {
      final List<Location> locations = await locationFromAddress(query);
      final List<Map<String, dynamic>> results = [];
      for (var i = 0; i < locations.length && i < 3; i++) {
        final loc = locations[i];
        final placemarks =
            await placemarkFromCoordinates(loc.latitude, loc.longitude);
        if (placemarks.isNotEmpty) {
          final p = placemarks.first;
          final addr =
              "${p.street ?? ''}, ${p.postalCode ?? ''} ${p.locality ?? ''}, ${p.country ?? ''}";
          results.add({
            "description": addr,
            "lat": loc.latitude,
            "lng": loc.longitude,
          });
        }
      }
      setState(() {
        _suggestions = results;
        _isSearching = false;
      });
    } catch (e) {
      dev.log("Fallback geocoding autocomplete error: $e");
      setState(() {
        _isSearching = false;
      });
    }
  }

  Future<Map<String, double>?> _getCoordinates(String placeId) async {
    try {
      final dio = Dio();
      final url = "https://maps.googleapis.com/maps/api/place/details/json";
      final response = await dio.get(url, queryParameters: {
        "place_id": placeId,
        "key": kGoogleMapsApiKey,
      });
      if (response.data["status"] == "OK") {
        final location = response.data["result"]["geometry"]["location"];
        return {
          "lat": location["lat"] as double,
          "lng": location["lng"] as double,
        };
      }
    } catch (e) {
      dev.log("Place details coordinates fetching error: $e");
    }
    return null;
  }

  Future<void> _selectSuggestion(Map<String, dynamic> suggestion) async {
    _focusNode.unfocus();
    setState(() {
      _suggestions = [];
      _textController.clear();
      _address = suggestion["description"];
    });

    double? selectedLat;
    double? selectedLng;

    if (suggestion.containsKey("lat") && suggestion.containsKey("lng")) {
      selectedLat = suggestion["lat"];
      selectedLng = suggestion["lng"];
    } else if (suggestion.containsKey("place_id")) {
      setState(() {
        _isSearching = true;
      });
      final coords = await _getCoordinates(suggestion["place_id"]);
      setState(() {
        _isSearching = false;
      });
      if (coords != null) {
        selectedLat = coords["lat"];
        selectedLng = coords["lng"];
      }
    }

    if (selectedLat != null && selectedLng != null) {
      setState(() {
        _latitude = selectedLat!;
        _longitude = selectedLng!;
      });

      // Update values in appData
      await appData.write(kKeySelectedLat, selectedLat);
      await appData.write(kKeySelectedLng, selectedLng);
      await appData.write(kKeySelectedLocation, _address);

      // Animate map camera
      _animateCamera(selectedLat, selectedLng);
    }
  }

  void _animateCamera(double lat, double lng) {
    if (Platform.isIOS && _appleMapController != null) {
      _appleMapController!.animateCamera(
        amaps.CameraUpdate.newLatLng(
          amaps.LatLng(lat, lng),
        ),
      );
    } else if (!Platform.isIOS && _googleMapController != null) {
      _googleMapController!.animateCamera(
        gmaps.CameraUpdate.newLatLng(
          gmaps.LatLng(lat, lng),
        ),
      );
    }
  }

  Future<void> _getCurrentLocationAndCenter() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return;
      }

      if (!mounted) return;
      setState(() {
        _isSearching = true;
      });

      final Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      String addressName = "Location";
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        addressName =
            "${place.street ?? ''}, ${place.administrativeArea ?? ''}, ${place.country ?? ''}";
        addressName = addressName.replaceAll(RegExp(r'^,\s*'), '');
      }

      if (!mounted) return;
      setState(() {
        _latitude = position.latitude;
        _longitude = position.longitude;
        _address = addressName;
        _textController.clear();
        _isSearching = false;
      });

      // Update values in appData
      await appData.write(kKeySelectedLat, position.latitude);
      await appData.write(kKeySelectedLng, position.longitude);
      await appData.write(kKeySelectedLocation, addressName);

      // Animate map camera
      _animateCamera(position.latitude, position.longitude);
    } catch (e) {
      dev.log("Error locating current user location: $e");
      if (!mounted) return;
      setState(() {
        _isSearching = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Markers definitions
    final Set<gmaps.Marker> googleMarkers = {
      gmaps.Marker(
        markerId: const gmaps.MarkerId('selected_location'),
        position: gmaps.LatLng(_latitude, _longitude),
        infoWindow: gmaps.InfoWindow(title: _address),
      ),
    };

    final Set<amaps.Annotation> appleAnnotations = {
      amaps.Annotation(
        annotationId: amaps.AnnotationId('selected_location'),
        position: amaps.LatLng(_latitude, _longitude),
        infoWindow: amaps.InfoWindow(title: _address),
      ),
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Map View Section with Locate Button
        Stack(
          children: [
            MapHelper.getMapView(
              height: 380.h,
              latitude: _latitude,
              longitude: _longitude,
              onMapCreatedGoogle: (controller) {
                _googleMapController = controller;
              },
              onMapCreatedApple: (controller) {
                _appleMapController = controller;
              },
              googleMarkers: googleMarkers,
              appleAnnotations: appleAnnotations,
            ),
            Positioned(
              right: 16.w,
              bottom: 16.h,
              child: GestureDetector(
                onTap: _getCurrentLocationAndCenter,
                child: Container(
                  width: 48.r,
                  height: 48.r,
                  decoration: BoxDecoration(
                    color: AppColors.cFFFFFF,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: _isSearching
                        ? SizedBox(
                            width: 20.r,
                            height: 20.r,
                            child: const WaitingWidget(),
                          )
                        : Icon(
                            Icons.my_location,
                            color: AppColors.allPrimaryColor,
                            size: 22.r,
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),

        UIHelper.verticalSpace(20.h),

        // Bottom Form Section
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat('MMMM yyyy', 'fr')
                    .format(DateTime.now())
                    .replaceFirstMapped(
                        RegExp(r'^[a-z]'), (m) => m[0]!.toUpperCase()),
                style: TextFontStyle.textStyle20c191919Inter600,
              ),
              UIHelper.verticalSpace(16.h),

              // Address Input
              CustomTextFormField(
                controller: _textController,
                focusNode: _focusNode,
                hintText: "Rechercher une adresse...",
                drawLabel: false,
                prefixIcon: Assets.icons.locationOutlinedGrey.image(
                  width: 20.w,
                  height: 20.w,
                ),
                fillColor: AppColors.cFFFFFF,
                borderColor: AppColors.cE3E3E3.withValues(alpha: 0.5),
                onChanged: _onSearchChanged,
              ),

              // Suggestions overlay layout
              if (_suggestions.isNotEmpty)
                Container(
                  margin: EdgeInsets.only(top: 8.h),
                  decoration: BoxDecoration(
                    color: AppColors.cFFFFFF,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: AppColors.cEEEEEE),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  constraints: BoxConstraints(maxHeight: 200.h),
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    itemCount: _suggestions.length,
                    separatorBuilder: (context, index) => const Divider(
                      height: 1,
                      color: AppColors.cEEEEEE,
                    ),
                    itemBuilder: (context, index) {
                      final suggestion = _suggestions[index];
                      return ListTile(
                        leading: Icon(
                          Icons.location_on_outlined,
                          color: AppColors.c191919,
                          size: 20.r,
                        ),
                        title: Text(
                          suggestion["description"],
                          style: TextFontStyle.textStyle14c1B1B1BInterTight500,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        onTap: () => _selectSuggestion(suggestion),
                      );
                    },
                  ),
                ),

              UIHelper.verticalSpace(20.h),

              // Current Location / Address Info Below Search
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 2.h),
                    child: Assets.icons.sendOutlinedBlack.image(
                      width: 20.w,
                      height: 20.w,
                    ),
                  ),
                  UIHelper.horizontalSpace(12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Adresse sélectionnée :",
                          style: TextFontStyle.textStyle14c4D4D4DInterTight500
                              .copyWith(
                            color: AppColors.c191919,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        UIHelper.verticalSpace(4.h),
                        Text(
                          _address,
                          style: TextFontStyle.textStyle14c1B1B1BInterTight500
                              .copyWith(
                            color: AppColors.c4D4D4D,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              UIHelper.verticalSpace(30.h),

              // Action Button
              SafeArea(
                top: false,
                child: CustomButton(
                  onPressed: () {
                    NavigationService.navigateTo(Routes.prestationsScreen);
                  },
                  title: "Continuer",
                  height: 55.h,
                ),
              ),
              UIHelper.verticalSpace(10.h),
            ],
          ),
        ),
      ],
    );
  }
}

import 'dart:async';
import 'dart:developer' as dev;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../constants/app_constants.dart';
import '../constants/text_font_style.dart';
import '../gen/colors.gen.dart';
import '../helpers/di.dart';
import '../helpers/location_service.dart';
import '../helpers/ui_helpers.dart';
import '../networks/api_acess.dart';
import 'custom_button.dart';
import 'custom_toast.dart';

class AddressSearchBottomSheet extends StatefulWidget {
  final Function(double lat, double lng, String address)? onLocationSelected;

  const AddressSearchBottomSheet({
    super.key,
    this.onLocationSelected,
  });

  static Future<void> show(
    BuildContext context, {
    Function(double lat, double lng, String address)? onLocationSelected,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddressSearchBottomSheet(
        onLocationSelected: onLocationSelected,
      ),
    );
  }

  @override
  State<AddressSearchBottomSheet> createState() =>
      _AddressSearchBottomSheetState();
}

class _AddressSearchBottomSheetState extends State<AddressSearchBottomSheet> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final LocationService _locationService = LocationService.instance;

  Timer? _debounce;
  bool _isSearching = false;
  bool _isGpsLoading = false;
  List<Map<String, dynamic>> _suggestions = [];

  final List<Map<String, dynamic>> _presetCities = const [
    {"name": "Paris", "lat": 48.8566, "lng": 2.3522},
    {"name": "Lyon", "lat": 45.7640, "lng": 4.8357},
    {"name": "Marseille", "lat": 43.2965, "lng": 5.3698},
    {"name": "Toulouse", "lat": 43.6047, "lng": 1.4442},
    {"name": "Nice", "lat": 43.7102, "lng": 7.2620},
    {"name": "Bordeaux", "lat": 44.8378, "lng": -0.5792},
    {"name": "Lille", "lat": 50.6292, "lng": 3.0573},
    {"name": "Strasbourg", "lat": 48.5734, "lng": 7.7521},
    {"name": "Nantes", "lat": 47.2184, "lng": -1.5536},
    {"name": "Montpellier", "lat": 43.6108, "lng": 3.8767},
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    if (query.trim().isEmpty) {
      setState(() {
        _suggestions = [];
        _isSearching = false;
      });
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 350), () {
      _fetchSuggestions(query.trim());
    });
  }

  Future<void> _fetchSuggestions(String query) async {
    setState(() => _isSearching = true);

    try {
      final dio = Dio();
      const url =
          "https://maps.googleapis.com/maps/api/place/autocomplete/json";
      final response = await dio.get(url, queryParameters: {
        "input": query,
        "key": kGoogleMapsApiKey,
        "language": "fr",
      });

      if (response.data["status"] == "OK") {
        final predictions = response.data["predictions"] as List;
        if (mounted) {
          setState(() {
            _suggestions = predictions
                .map((p) => {
                      "description": p["description"] as String,
                      "place_id": p["place_id"] as String,
                    })
                .toList();
            _isSearching = false;
          });
        }
        return;
      }
    } catch (e) {
      dev.log("Google Places autocomplete error: $e");
    }

    // Native geocoding fallback
    try {
      final List<Location> locations = await locationFromAddress(query);
      final List<Map<String, dynamic>> results = [];
      for (var i = 0; i < locations.length && i < 4; i++) {
        final loc = locations[i];
        final placemarks =
            await placemarkFromCoordinates(loc.latitude, loc.longitude);
        if (placemarks.isNotEmpty) {
          final p = placemarks.first;
          final addr =
              "${p.street ?? ''}, ${p.postalCode ?? ''} ${p.locality ?? ''}, ${p.country ?? ''}"
                  .replaceAll(RegExp(r'^[,\s]+|[,\s]+$'), '');
          results.add({
            "description": addr.isNotEmpty ? addr : query,
            "lat": loc.latitude,
            "lng": loc.longitude,
          });
        }
      }
      if (mounted) {
        setState(() {
          _suggestions = results;
          _isSearching = false;
        });
      }
    } catch (e) {
      dev.log("Fallback geocoding error: $e");
      if (mounted) {
        setState(() => _isSearching = false);
      }
    }
  }

  Future<void> _selectSuggestion(Map<String, dynamic> item) async {
    _focusNode.unfocus();
    double? lat = item["lat"] as double?;
    double? lng = item["lng"] as double?;
    String address = item["description"] as String;

    if (lat == null || lng == null) {
      final String? placeId = item["place_id"] as String?;
      if (placeId != null) {
        final coords = await _getCoordinatesFromPlaceId(placeId);
        if (coords != null) {
          lat = coords["lat"];
          lng = coords["lng"];
        }
      }
    }

    if (lat == null || lng == null) {
      try {
        final locations = await locationFromAddress(address);
        if (locations.isNotEmpty) {
          lat = locations.first.latitude;
          lng = locations.first.longitude;
        }
      } catch (e) {
        dev.log("Could not geocode address: $e");
      }
    }

    if (lat != null && lng != null) {
      await _applyLocation(lat: lat, lng: lng, address: address);
    } else {
      customToastMessage(
        "Erreur",
        "Impossible de récupérer les coordonnées pour cette adresse.",
      );
    }
  }

  Future<Map<String, double>?> _getCoordinatesFromPlaceId(
      String placeId) async {
    try {
      final dio = Dio();
      const url = "https://maps.googleapis.com/maps/api/place/details/json";
      final response = await dio.get(url, queryParameters: {
        "place_id": placeId,
        "key": kGoogleMapsApiKey,
      });
      if (response.data["status"] == "OK") {
        final location = response.data["result"]["geometry"]["location"];
        return {
          "lat": (location["lat"] as num).toDouble(),
          "lng": (location["lng"] as num).toDouble(),
        };
      }
    } catch (e) {
      dev.log("Place details error: $e");
    }
    return null;
  }

  Future<void> _selectPresetCity(
      String cityName, double lat, double lng) async {
    _focusNode.unfocus();
    await _applyLocation(lat: lat, lng: lng, address: "$cityName, France");
  }

  Future<void> _useCurrentGpsLocation() async {
    _focusNode.unfocus();
    setState(() => _isGpsLoading = true);

    try {
      final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (mounted) {
          _showEnableLocationDialog(
            title: "Service de localisation désactivé",
            message:
                "Veuillez activer la localisation de votre appareil pour utiliser votre position actuelle.",
            buttonText: "Paramètres de localisation",
            onOpenSettings: () => Geolocator.openLocationSettings(),
          );
        }
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever) {
        if (mounted) {
          _showEnableLocationDialog(
            title: "Permission de localisation requise",
            message:
                "L'accès à la localisation est désactivé. Veuillez l'activer dans les paramètres de votre appareil pour continuer.",
            buttonText: "Ouvrir les paramètres",
            onOpenSettings: () => Geolocator.openAppSettings(),
          );
        }
        return;
      }

      if (permission == LocationPermission.denied) {
        customToastMessage(
          "Information",
          "Permission de localisation refusée. Vous pouvez toujours saisir votre ville manuellement.",
        );
        return;
      }

      await _locationService.initialize(
        requestPermission: false,
        updateLocation: true,
      );

      final double? lat = appData.read(kKeySelectedLat);
      final double? lng = appData.read(kKeySelectedLng);
      final String address =
          appData.read(kKeySelectedLocation) ?? "Position actuelle";

      if (lat != null && lng != null) {
        await _applyLocation(
          lat: lat,
          lng: lng,
          address: address,
          alreadySaved: true,
        );
      } else {
        customToastMessage(
          "Erreur",
          "Impossible de récupérer votre position GPS. Veuillez réessayer ou choisir une ville.",
        );
      }
    } catch (e) {
      dev.log("GPS fetch error: $e");
    } finally {
      if (mounted) {
        setState(() => _isGpsLoading = false);
      }
    }
  }

  void _showEnableLocationDialog({
    required String title,
    required String message,
    required String buttonText,
    required Future<bool> Function() onOpenSettings,
  }) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.cFFFFFF,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Branded concentric wave icon badge
            Container(
              width: 76.r,
              height: 76.r,
              decoration: BoxDecoration(
                color: AppColors.allPrimaryColor.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Container(
                  width: 54.r,
                  height: 54.r,
                  decoration: BoxDecoration(
                    color: AppColors.allPrimaryColor.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.location_on_rounded,
                      size: 30.sp,
                      color: AppColors.allPrimaryColor,
                    ),
                  ),
                ),
              ),
            ),
            UIHelper.verticalSpace(16.h),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextFontStyle.textStyle16c191919Inter600.copyWith(
                fontSize: 17.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            UIHelper.verticalSpace(10.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextFontStyle.textStyle14c737373Inter400.copyWith(
                height: 1.4,
              ),
            ),
            UIHelper.verticalSpace(24.h),
            CustomButton(
              onPressed: () async {
                Navigator.of(ctx).pop();
                await onOpenSettings();
              },
              title: buttonText,
              height: 48.h,
              backgroundColor: AppColors.allPrimaryColor,
              foregroundColor: AppColors.cFFFFFF,
              textStyle: TextFontStyle.textStyle14c191919Inter500.copyWith(
                color: AppColors.cFFFFFF,
                fontWeight: FontWeight.w600,
              ),
              borderRadius: BorderRadius.circular(12.r),
            ),
            UIHelper.verticalSpace(10.h),
            CustomButton(
              onPressed: () => Navigator.of(ctx).pop(),
              title: "Annuler",
              height: 48.h,
              backgroundColor: AppColors.cF4F4F4,
              foregroundColor: AppColors.c191919,
              textStyle: TextFontStyle.textStyle14c191919Inter500.copyWith(
                fontWeight: FontWeight.w600,
              ),
              borderRadius: BorderRadius.circular(12.r),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _applyLocation({
    required double lat,
    required double lng,
    required String address,
    bool alreadySaved = false,
  }) async {
    if (!alreadySaved) {
      await _locationService.setManualLocation(
        lat: lat,
        lng: lng,
        address: address,
      );
    }

    if (appData.read(kKeyIsLoggedIn) == true) {
      postLocationUpdateRxObj.postLocationUpdate(
        latitude: lat,
        longitude: lng,
      );
    }

    widget.onLocationSelected?.call(lat, lng, address);

    if (mounted) {
      Navigator.of(context).pop();
      customToastMessage("Succès", "Adresse sélectionnée avec succès.");
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      constraints: BoxConstraints(
        maxHeight: 0.85.sh,
      ),
      padding: EdgeInsets.only(
        bottom: bottomInset > 0 ? bottomInset : 24.h,
      ),
      decoration: BoxDecoration(
        color: AppColors.cFFFFFF,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          UIHelper.verticalSpace(12.h),
          // Drag handle
          Container(
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: AppColors.cE3E3E3,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          UIHelper.verticalSpace(16.h),
          // Header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Choisir une adresse",
                  style: TextFontStyle.textStyle18c191919InterTight600,
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    padding: EdgeInsets.all(6.r),
                    decoration: const BoxDecoration(
                      color: AppColors.cF4F4F4,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.close,
                      size: 18.sp,
                      color: AppColors.c191919,
                    ),
                  ),
                ),
              ],
            ),
          ),
          UIHelper.verticalSpace(16.h),
          // Search TextField
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.cF4F4F4,
                borderRadius: BorderRadius.circular(14.r),
                border: Border.all(
                  color: _focusNode.hasFocus
                      ? AppColors.allPrimaryColor
                      : Colors.transparent,
                  width: 1.2,
                ),
              ),
              child: TextField(
                controller: _searchController,
                focusNode: _focusNode,
                onChanged: _onSearchChanged,
                textInputAction: TextInputAction.search,
                style: TextFontStyle.textStyle14c191919Inter500,
                decoration: InputDecoration(
                  hintText: "Rechercher une ville, adresse, code postal...",
                  hintStyle: TextFontStyle.textStyle14c737373Inter400,
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: AppColors.allPrimaryColor,
                    size: 22.sp,
                  ),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: Icon(
                            Icons.clear,
                            size: 18.sp,
                            color: AppColors.c737373,
                          ),
                          onPressed: () {
                            _searchController.clear();
                            _onSearchChanged("");
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 14.h,
                  ),
                ),
              ),
            ),
          ),
          UIHelper.verticalSpace(12.h),
          // "Use current GPS location" button
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: InkWell(
              onTap: _isGpsLoading ? null : _useCurrentGpsLocation,
              borderRadius: BorderRadius.circular(12.r),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: AppColors.allPrimaryColor.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: AppColors.allPrimaryColor.withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  children: [
                    _isGpsLoading
                        ? SizedBox(
                            width: 20.r,
                            height: 20.r,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.allPrimaryColor,
                              ),
                            ),
                          )
                        : Icon(
                            Icons.my_location_rounded,
                            color: AppColors.allPrimaryColor,
                            size: 20.sp,
                          ),
                    UIHelper.horizontalSpace(12.w),
                    Expanded(
                      child: Text(
                        _isGpsLoading
                            ? "Localisation en cours..."
                            : "Utiliser ma position actuelle",
                        style:
                            TextFontStyle.textStyle14c191919Inter600.copyWith(
                          color: AppColors.allPrimaryColor,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 14.sp,
                      color: AppColors.allPrimaryColor,
                    ),
                  ],
                ),
              ),
            ),
          ),
          UIHelper.verticalSpace(12.h),
          const Divider(height: 1, color: AppColors.cF2F2F2),
          // Suggestions list or Popular Cities
          Expanded(
            child: _isSearching
                ? const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.allPrimaryColor,
                      ),
                    ),
                  )
                : _suggestions.isNotEmpty
                    ? ListView.separated(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 10.h,
                        ),
                        itemCount: _suggestions.length,
                        separatorBuilder: (context, index) =>
                            const Divider(height: 1, color: AppColors.cF4F4F4),
                        itemBuilder: (context, index) {
                          final item = _suggestions[index];
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: Container(
                              padding: EdgeInsets.all(8.r),
                              decoration: const BoxDecoration(
                                color: AppColors.cF4F4F4,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.location_on_outlined,
                                color: AppColors.allPrimaryColor,
                                size: 18.sp,
                              ),
                            ),
                            title: Text(
                              item["description"] ?? "",
                              style: TextFontStyle.textStyle14c191919Inter500,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            onTap: () => _selectSuggestion(item),
                          );
                        },
                      )
                    : SingleChildScrollView(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 12.h,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Villes populaires",
                              style: TextFontStyle.textStyle14c737373Inter500,
                            ),
                            UIHelper.verticalSpace(12.h),
                            Wrap(
                              spacing: 8.w,
                              runSpacing: 8.h,
                              children: _presetCities.map((city) {
                                return ActionChip(
                                  backgroundColor: AppColors.cF4F4F4,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.r),
                                    side: const BorderSide(
                                      color: Colors.transparent,
                                    ),
                                  ),
                                  avatar: Icon(
                                    Icons.place_outlined,
                                    size: 16.sp,
                                    color: AppColors.allPrimaryColor,
                                  ),
                                  label: Text(
                                    city["name"],
                                    style: TextFontStyle
                                        .textStyle14c191919Inter500,
                                  ),
                                  onPressed: () => _selectPresetCity(
                                    city["name"],
                                    city["lat"],
                                    city["lng"],
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}

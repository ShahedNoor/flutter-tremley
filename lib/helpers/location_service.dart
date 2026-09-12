import 'dart:developer';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import 'package:rxdart/rxdart.dart';

import '../constants/app_constants.dart';
import 'di.dart';

class LocationService {
  static final LocationService _singleton = LocationService._internal();

  LocationService._internal();

  static LocationService get instance => _singleton;

  bool isLocationPermissionGranted = false;
  bool isLocationServiceEnabled = false;
  bool isLocationPermissionChecked = false;
  bool isLocationPermissionPermanentlyDenied = false;

  final BehaviorSubject<Map<String, dynamic>?> _locationSubject =
      BehaviorSubject<Map<String, dynamic>?>.seeded(null);

  Stream<Map<String, dynamic>?> get locationStream => _locationSubject.stream;

  bool get hasLocation =>
      appData.read(kKeySelectedLat) != null &&
      appData.read(kKeySelectedLng) != null;

  String? get currentLocationName => appData.read(kKeySelectedLocation);
  double? get currentLat => appData.read(kKeySelectedLat);
  double? get currentLng => appData.read(kKeySelectedLng);

  Future<void> setManualLocation({
    required double lat,
    required double lng,
    required String address,
  }) async {
    await appData.write(kKeySelectedLat, lat);
    await appData.write(kKeySelectedLng, lng);
    await appData.write(kKeySelectedLocation, address);
    _locationSubject.add({
      'lat': lat,
      'lng': lng,
      'address': address,
    });
  }

  Future<void>? _initializationFuture;

  Future<void> initialize({
    bool requestPermission = true,
    bool updateLocation = true,
  }) async {
    if (_initializationFuture != null) {
      await _initializationFuture;
      return;
    }

    _initializationFuture = _checkLocationPermission(
      requestPermission: requestPermission,
      updateLocation: updateLocation,
    );

    try {
      await _initializationFuture;
    } finally {
      _initializationFuture = null;
    }
  }

  Future<void> _checkLocationPermission({
    bool requestPermission = true,
    bool updateLocation = true,
  }) async {
    isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!isLocationServiceEnabled) {
      isLocationPermissionGranted = false;
      isLocationPermissionPermanentlyDenied = false;
      isLocationPermissionChecked = true;
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      if (requestPermission) {
        permission = await Geolocator.requestPermission();
      } else {
        isLocationPermissionGranted = false;
        isLocationPermissionPermanentlyDenied =
            permission == LocationPermission.deniedForever;
        isLocationPermissionChecked = true;
        return;
      }

      if (permission == LocationPermission.denied) {
        isLocationPermissionGranted = false;
        isLocationPermissionPermanentlyDenied = false;
        isLocationPermissionChecked = true;
        return;
      }

      if (permission == LocationPermission.deniedForever) {
        isLocationPermissionGranted = false;
        isLocationPermissionPermanentlyDenied = true;
        isLocationPermissionChecked = true;
        return;
      }
    }

    isLocationPermissionGranted = true;
    isLocationPermissionPermanentlyDenied = false;

    if (updateLocation) {
      await _updateLocation();
    }

    isLocationPermissionChecked = true;
  }

  Future<void> _updateLocation() async {
    try {
      Position? position;
      try {
        position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.medium,
          timeLimit: const Duration(seconds: 5),
        );
      } catch (e) {
        log('getCurrentPosition timed out or failed: $e. Falling back to last known position');
        position = await Geolocator.getLastKnownPosition();
      }

      if (position == null) {
        log('No GPS position available');
        return;
      }

      await appData.write(kKeySelectedLat, position.latitude);
      await appData.write(kKeySelectedLng, position.longitude);

      String locationName = "Position actuelle";
      try {
        final List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        ).timeout(const Duration(seconds: 3));

        if (placemarks.isNotEmpty) {
          final Placemark place = placemarks.first;
          final parts = [
            place.street,
            place.locality ?? place.administrativeArea,
            place.country
          ].where((s) => s != null && s.trim().isNotEmpty).toList();
          if (parts.isNotEmpty) {
            locationName = parts.join(", ");
          }
        }
      } catch (e) {
        log('Placemark reverse geocoding error or timeout: $e');
      }

      await appData.write(kKeySelectedLocation, locationName);
      _locationSubject.add({
        'lat': position.latitude,
        'lng': position.longitude,
        'address': locationName,
      });

      log(
        "Location updated: Lat: ${position.latitude}, Long: ${position.longitude}, Name: $locationName",
      );
    } catch (e) {
      log('Error fetching location: $e');
    }
  }

  Future<String?> getLocationNameFromCoordinates(
    double lat,
    double long,
  ) async {
    try {
      final List<Placemark> placemarks =
          await placemarkFromCoordinates(lat, long);

      if (placemarks.isNotEmpty) {
        final Placemark place = placemarks.first;
        return "${place.street}, ${place.administrativeArea}, ${place.country}";
      }

      log('No placemarks found');
      return null;
    } catch (e) {
      log('Error fetching location: $e');
      return null;
    }
  }

  String? calculateDistance(double lat, double long) {
    try {
      final double? savedLat = appData.read(kKeySelectedLat);
      final double? savedLong = appData.read(kKeySelectedLng);

      if (savedLat == null || savedLong == null) {
        log('Location data is not available in storage.');
        return null;
      }

      final double distanceInMeters = Geolocator.distanceBetween(
        savedLat,
        savedLong,
        lat,
        long,
      );

      if (distanceInMeters < 1000) {
        return "${distanceInMeters.toInt()}m";
      }

      final double distanceInKilometers = distanceInMeters / 1000;
      return "${distanceInKilometers.toInt()}km";
    } catch (e) {
      log('Error calculating distance: $e');
      return null;
    }
  }
}

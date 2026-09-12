import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmaps;
import 'package:apple_maps_flutter/apple_maps_flutter.dart' as amaps;

final class MapHelper {
  MapHelper._();

  static Widget getMapView({
    required double height,
    double latitude = 48.8566,
    double longitude = 2.3522,
    double zoom = 14.0,
    void Function(gmaps.GoogleMapController)? onMapCreatedGoogle,
    void Function(amaps.AppleMapController)? onMapCreatedApple,
    Set<gmaps.Marker> googleMarkers = const {},
    Set<amaps.Annotation> appleAnnotations = const {},
  }) {
    if (Platform.isIOS) {
      return SizedBox(
        height: height,
        child: amaps.AppleMap(
          initialCameraPosition: amaps.CameraPosition(
            target: amaps.LatLng(latitude, longitude),
            zoom: zoom,
          ),
          mapType: amaps.MapType.standard,
          onMapCreated: onMapCreatedApple,
          annotations: appleAnnotations,
        ),
      );
    } else {
      return SizedBox(
        height: height,
        child: gmaps.GoogleMap(
          initialCameraPosition: gmaps.CameraPosition(
            target: gmaps.LatLng(latitude, longitude),
            zoom: zoom,
          ),
          mapType: gmaps.MapType.normal,
          onMapCreated: onMapCreatedGoogle,
          markers: googleMarkers,
        ),
      );
    }
  }
}

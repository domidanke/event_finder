import 'dart:io';
import 'dart:math';

import 'package:event_finder/services/state.service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/event.dart';

class LocationService {
  factory LocationService() {
    return _singleton;
  }
  LocationService._internal();
  static final LocationService _singleton = LocationService._internal();

  bool isRequestingPermission = false;

  Future<void> handlePermission() async {
    if (isRequestingPermission) return;
    var permission = await Geolocator.checkPermission();
    if (permission != LocationPermission.whileInUse &&
        permission != LocationPermission.always) {
      isRequestingPermission = true;
      var newPermission = await Geolocator.requestPermission();
      isRequestingPermission = false;
      if (newPermission == LocationPermission.whileInUse ||
          newPermission == LocationPermission.always) {
        StateService().currentUserLocation =
            await Geolocator.getCurrentPosition();
      } else {
        StateService().currentUserLocation = null;
      }
    } else {
      StateService().currentUserLocation = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
    }
  }

  double getDistanceFromLatLonInKm(LatLng l1, LatLng l2) {
    var R = 6371; // Radius of the earth in km
    var dLat = _deg2rad(l2.latitude - l1.latitude); // deg2rad below
    var dLon = _deg2rad(l2.longitude - l1.longitude);
    var a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_deg2rad(l1.latitude)) *
            cos(_deg2rad(l2.latitude)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    var c = 2 * atan2(sqrt(a), sqrt(1 - a));
    var d = R * c; // Distance in km
    return double.parse((d).toStringAsFixed(1));
  }

  double _deg2rad(double deg) {
    return deg * (pi / 180);
  }

  Future<void> openEventInMap(Event event) async {
    final googleUrl = createCoordinatesUri(
        event.location.geoPoint.latitude, event.location.geoPoint.longitude);
    if (await canLaunchUrl(googleUrl)) {
      await launchUrl(
        googleUrl,
        mode: LaunchMode.externalApplication,
      );
    } else {
      throw 'Could not open the map.';
    }
  }

  /// Returns a [Uri] that can be launched on the current platform
  /// to open a maps application showing coordinates ([latitude] and [longitude]).
  static Uri createCoordinatesUri(double latitude, double longitude) {
    Uri uri;
    if (Platform.isAndroid) {
      var query = '$latitude,$longitude';
      uri = Uri(scheme: 'geo', host: '0,0', queryParameters: {'q': query});
    } else if (Platform.isIOS) {
      uri = Uri.https('www.google.com', '/maps/search/',
          {'api': '1', 'query': '$latitude,$longitude'});
    } else {
      uri = Uri.https('www.google.com', '/maps/search/',
          {'api': '1', 'query': '$latitude,$longitude'});
    }

    return uri;
  }
}

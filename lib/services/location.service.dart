import 'package:cloud_firestore/cloud_firestore.dart';

class LocationService {
  factory LocationService() {
    return _singleton;
  }
  LocationService._internal();
  static final LocationService _singleton = LocationService._internal();

  void getDocumentNearBy(double latitude, double longitude, double distance) {
    // ~1 mile of lat and lon in degrees
    var lat = 0.0144927536231884;
    var lon = 0.0181818181818182;

    var lowerLat = latitude - (lat * distance);
    var lowerLon = longitude - (lon * distance);

    var greaterLat = latitude + (lat * distance);
    var greaterLon = longitude + (lon * distance);

    var lesserGeopoint = GeoPoint(lowerLat, lowerLon);
    var greaterGeopoint = GeoPoint(greaterLat, greaterLon);
    //var query = docRef.whereField("location", isGreaterThan: lesserGeopoint).whereField("location", isLessThan: greaterGeopoint)
  }
}

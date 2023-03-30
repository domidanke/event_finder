import 'package:cloud_firestore/cloud_firestore.dart';

class LocationData {
  const LocationData({
    this.geoPoint = const GeoPoint(0, 0),
    this.geoHash = '',
  });

  final GeoPoint geoPoint;
  final String geoHash;

  LocationData.fromJson(Map<String, Object?> json)
      : this(
            geoPoint: json['geopoint'] as GeoPoint,
            geoHash: json['geohash'] as String);

  toJson() {
    return {'geopoint': geoPoint, 'geohash': geoHash};
  }
}

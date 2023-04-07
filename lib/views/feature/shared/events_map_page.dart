import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_finder/models/event.dart';
import 'package:event_finder/services/firestore/event_doc.service.dart';
import 'package:event_finder/services/state.service.dart';
import 'package:event_finder/theme/theme.dart';
import 'package:event_finder/views/feature/shared/map_event_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class EventsMapPage extends StatefulWidget {
  const EventsMapPage({super.key});

  @override
  EventsMapPageState createState() => EventsMapPageState();
}

class EventsMapPageState extends State<EventsMapPage> {
  /// Detection radius (km) from the center point when running geo query.
  double _radiusInKm = 1;
  Set<Marker> _markers = {};
  List<Event> _events = [];
  int _numOfEventsInRadius = 0;
  final currentPosition = StateService().currentUserLocation!;
  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;

  /// Geo query [StreamSubscription].
  late StreamSubscription<List<DocumentSnapshot<Event>>> _subscription;

  /// Returns geo query [StreamSubscription] with listener.
  StreamSubscription<List<DocumentSnapshot<Event>>> _geoQuerySubscription({
    required GeoPoint centerGeoPoint,
    required double radiusInKm,
  }) =>
      GeoCollectionReference(EventDocService().eventsCollection)
          .subscribeWithin(
            center: GeoFirePoint(centerGeoPoint),
            radiusInKm: radiusInKm,
            field: 'location',
            geopointFrom: (data) => data.location.geoPoint,
            strictMode: true,
          )
          .listen(_updateMarkers);

  @override
  void initState() {
    addCustomIcon();
    _subscription = _geoQuerySubscription(
      centerGeoPoint: GeoPoint(
        currentPosition.latitude,
        currentPosition.longitude,
      ),
      radiusInKm: _radiusInKm,
    );
    super.initState();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  void addCustomIcon() {
    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(), 'assets/images/custom_marker.png')
        .then(
      (icon) {
        setState(() {
          markerIcon = icon;
        });
      },
    );
  }

  void _updateMarkers(List<DocumentSnapshot<Event>> documentSnapshots) {
    _numOfEventsInRadius = 0;
    _markers = <Marker>{};
    _events = [];
    for (final ds in documentSnapshots) {
      final event = ds.data()!;
      _numOfEventsInRadius++;
      _events.add(event);
      _markers.add(
        Marker(
          markerId: MarkerId(event.location.geoHash),
          position: LatLng(event.location.geoPoint.latitude,
              event.location.geoPoint.longitude),
          icon: markerIcon,
        ),
      );
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            GoogleMap(
              onMapCreated: (controller) async {
                final String json = await rootBundle
                    .loadString('assets/json_data/map_style.json');
                controller.setMapStyle(json);
              },
              myLocationButtonEnabled: false,
              myLocationEnabled: true,
              initialCameraPosition: CameraPosition(
                target:
                    LatLng(currentPosition.latitude, currentPosition.longitude),
                zoom: 13,
              ),
              markers: _markers,
              circles: {
                Circle(
                  circleId: const CircleId('value'),
                  center: LatLng(
                    currentPosition.latitude,
                    currentPosition.longitude,
                  ),
                  // multiple 1000 to convert from kilometers to meters.
                  radius: _radiusInKm * 1000,
                  fillColor: primaryColorTransparent,
                  strokeWidth: 0,
                ),
              },
            ),
            Positioned(
              top: 30,
              left: 10,
              right: 10,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Colors.black38,
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Events in ${_radiusInKm.toInt()}km Radius: '
                      '$_numOfEventsInRadius',
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 8),
                    Slider(
                      value: _radiusInKm,
                      min: 1,
                      max: 50,
                      divisions: 49,
                      label: '${_radiusInKm.toInt()}km',
                      onChanged: (value) {
                        _radiusInKm = value;
                        _subscription = _geoQuerySubscription(
                          centerGeoPoint: GeoPoint(
                            currentPosition.latitude,
                            currentPosition.longitude,
                          ),
                          radiusInKm: _radiusInKm,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 30,
              left: 10,
              right: 10,
              child: SizedBox(
                height: 210,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: _events
                      .map((event) => MapEventCard(event: event))
                      .toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

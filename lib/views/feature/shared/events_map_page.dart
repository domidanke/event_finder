import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_finder/models/event.dart';
import 'package:event_finder/services/firestore/event_doc.service.dart';
import 'package:event_finder/services/state.service.dart';
import 'package:event_finder/theme/theme.dart';
import 'package:event_finder/views/feature/shared/event_card.dart';
import 'package:event_finder/widgets/kk_back_button.dart';
import 'package:flutter/cupertino.dart';
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
      final now = DateTime.now();
      final startOfDay = DateTime(now.year, now.month, now.day);
      if (event.date.isBefore(startOfDay)) continue;
      _numOfEventsInRadius++;
      _events.add(event);
      _markers.add(
        Marker(
          infoWindow:
              InfoWindow(title: event.title, snippet: event.creatorName),
          markerId: MarkerId(event.location.geoHash),
          position: LatLng(event.location.geoPoint.latitude,
              event.location.geoPoint.longitude),
          icon: markerIcon,
        ),
      );
    }
    _events.sort((a, b) => a.date.compareTo(b.date));
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
              zoomControlsEnabled: false,
              mapToolbarEnabled: false,
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
                  fillColor: primaryBackgroundColor.withOpacity(0.5),
                  strokeWidth: 0,
                ),
              },
            ),
            Positioned(
              top: 10,
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
                    Row(
                      children: [
                        const KKBackButton(),
                        const SizedBox(
                          width: 20,
                        ),
                        Text(
                          'Events in ${_radiusInKm.toInt()}km Radius: '
                          '$_numOfEventsInRadius',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    SizedBox(width: double.infinity, child: _getSlider()),
                  ],
                ),
              ),
            ),
            if (_events.isNotEmpty)
              Positioned(
                bottom: 30,
                left: 10,
                right: 10,
                child: SizedBox(
                  height: 220,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: _events
                        .map((event) => EventCard(event: event))
                        .toList(),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _getSlider() {
    if (Platform.isAndroid) {
      return Slider(
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
      );
    } else {
      return CupertinoSlider(
        key: const Key('slider'),
        value: _radiusInKm,
        min: 1,
        max: 50,
        divisions: 49,
        onChanged: (double value) {
          _subscription = _geoQuerySubscription(
            centerGeoPoint: GeoPoint(
              currentPosition.latitude,
              currentPosition.longitude,
            ),
            radiusInKm: _radiusInKm,
          );
          _radiusInKm = value;
        },
      );
    }
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationSnippet extends StatefulWidget {
  const LocationSnippet({Key? key, required this.coordinates})
      : super(key: key);

  final LatLng coordinates;

  @override
  State<LocationSnippet> createState() => LocationSnippetState();
}

class LocationSnippetState extends State<LocationSnippet> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  @override
  void initState() {
    final marker = Marker(
      markerId: const MarkerId('address'),
      position: widget.coordinates,
      infoWindow: const InfoWindow(
        title: 'title',
        snippet: 'address',
      ),
    );
    setState(() {
      markers[const MarkerId('address')] = marker;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      rotateGesturesEnabled: false,
      scrollGesturesEnabled: false,
      myLocationButtonEnabled: false,
      mapType: MapType.normal,
      initialCameraPosition: CameraPosition(
        target: LatLng(markers[const MarkerId('address')]!.position.latitude,
            markers[const MarkerId('address')]!.position.longitude),
        zoom: 15,
      ),
      markers: markers.values.toSet(),
      onMapCreated: (GoogleMapController controller) async {
        final String json =
            await rootBundle.loadString('assets/json_data/map_style.json');
        controller.setMapStyle(json);
        _controller.complete(controller);
      },
    );
  }
}

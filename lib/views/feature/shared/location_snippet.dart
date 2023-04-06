import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
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
  late Future<List<Placemark>> _placeMarks;

  @override
  void initState() {
    _placeMarks = placemarkFromCoordinates(
        widget.coordinates.latitude, widget.coordinates.longitude);
    final marker = Marker(
      markerId: const MarkerId('address'),
      position: widget.coordinates,
    );
    setState(() {
      markers[const MarkerId('address')] = marker;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          rotateGesturesEnabled: false,
          scrollGesturesEnabled: false,
          myLocationButtonEnabled: false,
          mapType: MapType.normal,
          initialCameraPosition: CameraPosition(
            target: LatLng(
                markers[const MarkerId('address')]!.position.latitude,
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
        ),
        FutureBuilder(
          future: _placeMarks,
          builder:
              (BuildContext context, AsyncSnapshot<List<Placemark>> snapshot) {
            if (snapshot.hasData) {
              final placeMark = snapshot.data![0];
              return Positioned(
                bottom: 5,
                left: 10,
                right: 10,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Colors.black38,
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        placeMark.street!,
                      ),
                      Text(
                        '${placeMark.postalCode}, ${placeMark.subAdministrativeArea}',
                      ),
                    ],
                  ),
                ),
              );
            }
            return const Text('');
          },
        )
      ],
    );
  }
}

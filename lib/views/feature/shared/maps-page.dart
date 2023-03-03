import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapsPage extends StatefulWidget {
  const MapsPage({Key? key}) : super(key: key);

  @override
  State<MapsPage> createState() => MapsPageState();
}

class MapsPageState extends State<MapsPage> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  Future<CameraPosition> getLocation() async {
    await Geolocator.requestPermission();
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    return CameraPosition(
      target: LatLng(position.latitude, position.longitude),
      zoom: 14.4746,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: getLocation(),
        builder:
            (BuildContext context, AsyncSnapshot<CameraPosition> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return GoogleMap(
            myLocationEnabled: true,
            mapType: MapType.normal,
            initialCameraPosition: snapshot.data!,
            onMapCreated: (GoogleMapController controller) async {
              final String json = await rootBundle
                  .loadString('assets/json_data/map_style.json');
              controller.setMapStyle(json);
              _controller.complete(controller);
            },
          );
        },
      ),
    );
  }
}

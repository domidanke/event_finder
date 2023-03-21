import 'dart:async';

import 'package:event_finder/services/alert.service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapsPage extends StatefulWidget {
  const MapsPage({Key? key, required this.onAddressSelected}) : super(key: key);

  final Function(LatLng coordinates) onAddressSelected;

  @override
  State<MapsPage> createState() => MapsPageState();
}

class MapsPageState extends State<MapsPage> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  final _addressController = TextEditingController();

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
        body: Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                  flex: 4,
                  child: Container(
                    margin: const EdgeInsets.only(right: 10),
                    child: TextField(
                      controller: _addressController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Adresse',
                      ),
                    ),
                  )),
              Expanded(
                  child: ElevatedButton(
                      onPressed: () async {
                        if (_addressController.text.isEmpty) return;
                        try {
                          List<Location> locations = await locationFromAddress(
                              _addressController.text);
                          await _pinAddress(locations[0]);
                        } on Exception catch (e) {
                          debugPrint(e.toString());
                          AlertService()
                              .showAlert('Fehler', 'not_found', context);
                        }
                      },
                      child: const Icon(Icons.search))),
            ],
          ),
        ),
        if (markers[const MarkerId('address')] != null)
          Expanded(
              child: GoogleMap(
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
              final String json = await rootBundle
                  .loadString('assets/json_data/map_style.json');
              controller.setMapStyle(json);
              _controller.complete(controller);
            },
          )),
      ],
    ));
  }

  Future<void> _pinAddress(Location location) async {
    final coordinates = LatLng(location.latitude, location.longitude);
    if (markers[const MarkerId('address')] != null) {
      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: coordinates, zoom: 15)));
    }
    final marker = Marker(
      markerId: const MarkerId('address'),
      position: coordinates,
      infoWindow: const InfoWindow(
        title: 'title',
        snippet: 'address',
      ),
    );
    setState(() {
      markers[const MarkerId('address')] = marker;
    });
    widget.onAddressSelected(coordinates);
  }
}

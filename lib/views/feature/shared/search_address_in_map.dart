import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_finder/services/alert.service.dart';
import 'package:event_finder/services/search.service.dart';
import 'package:event_finder/widgets/user_search_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SearchAddressInMap extends StatefulWidget {
  const SearchAddressInMap({Key? key, required this.onAddressSelected})
      : super(key: key);

  final Function(GeoFirePoint geoFirePoint) onAddressSelected;

  @override
  State<SearchAddressInMap> createState() => SearchAddressInMapState();
}

class SearchAddressInMapState extends State<SearchAddressInMap> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              const Expanded(
                child: UserSearchField(
                  hintText: 'Adresse',
                ),
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward),
                onPressed: () async {
                  FocusScope.of(context).unfocus();
                  if (SearchService().searchText.isEmpty) return;
                  try {
                    List<Location> locations =
                        await locationFromAddress(SearchService().searchText);
                    await _pinAddress(locations[0]);
                  } on Exception catch (e) {
                    debugPrint(e.toString());
                    AlertService().showAlert('Fehler', 'not_found', context);
                  }
                },
              ),
            ],
          ),
        ),
        if (markers[const MarkerId('address')] != null)
          Container(
            margin: const EdgeInsets.all(12),
            height: 350,
            decoration: BoxDecoration(
                border: Border.all(width: 0.2, color: Colors.white)),
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
            ),
          ),
      ],
    );
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

    final GeoFirePoint geoFirePoint =
        GeoFirePoint(GeoPoint(coordinates.latitude, coordinates.longitude));
    widget.onAddressSelected(geoFirePoint);
  }
}

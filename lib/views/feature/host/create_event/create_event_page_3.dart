import 'package:event_finder/views/feature/shared/maps_page.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CreateEventPage3 extends StatefulWidget {
  const CreateEventPage3({Key? key}) : super(key: key);

  @override
  State<CreateEventPage3> createState() => _CreateEventPage3State();
}

class _CreateEventPage3State extends State<CreateEventPage3> {
  @override
  Widget build(BuildContext context) {
    return MapsPage(
      onAddressSelected: (LatLng coordinates) {
        /// TODO Map to event :)
        print(coordinates.latitude);
        print(coordinates.longitude);
      },
    );
  }
}

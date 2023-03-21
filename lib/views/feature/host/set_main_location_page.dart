import 'package:event_finder/services/firestore_service.dart';
import 'package:event_finder/views/feature/shared/search_address_in_map.dart';
import 'package:event_finder/widgets/kk_button.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SetMainLocationPage extends StatefulWidget {
  const SetMainLocationPage({Key? key}) : super(key: key);

  @override
  State<SetMainLocationPage> createState() => _SetMainLocationPageState();
}

class _SetMainLocationPageState extends State<SetMainLocationPage> {
  LatLng? _selectedCoordinates;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 7,
              child: SearchAddressInMap(
                onAddressSelected: (LatLng coordinates) {
                  print(coordinates.latitude);
                  print(coordinates.longitude);
                  setState(() {
                    _selectedCoordinates = coordinates;
                  });
                },
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Opacity(
              opacity: _selectedCoordinates == null ? 0.4 : 1,
              child: KKButton(
                onPressed: () async {
                  if (_selectedCoordinates == null) return;
                  await FirestoreService()
                      .saveMainLocationData(_selectedCoordinates!);
                },
                buttonText: 'Speichern',
              ),
            )
          ],
        ),
      ),
    );
  }
}

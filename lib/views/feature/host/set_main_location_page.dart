import 'package:event_finder/services/firestore/user_doc.service.dart';
import 'package:event_finder/services/state.service.dart';
import 'package:event_finder/views/feature/shared/search_address_in_map.dart';
import 'package:event_finder/widgets/kk_button_async.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SetMainLocationPage extends StatefulWidget {
  const SetMainLocationPage({Key? key}) : super(key: key);

  @override
  State<SetMainLocationPage> createState() => _SetMainLocationPageState();
}

class _SetMainLocationPageState extends State<SetMainLocationPage> {
  LatLng? _selectedCoordinates;
  bool _isSaving = false;
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
              child: KKButtonAsync(
                onPressed: () async {
                  if (_selectedCoordinates == null) return;
                  setState(() {
                    _isSaving = true;
                  });
                  await UserDocService()
                      .saveMainLocationData(_selectedCoordinates!);
                  StateService().currentUserMainLocation =
                      _selectedCoordinates!;
                  setState(() {
                    _isSaving = false;
                  });
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Main Location aktualisiert.')),
                    );
                    Navigator.pop(context);
                  }
                },
                buttonText: 'Speichern',
                loading: _isSaving,
              ),
            )
          ],
        ),
      ),
    );
  }
}

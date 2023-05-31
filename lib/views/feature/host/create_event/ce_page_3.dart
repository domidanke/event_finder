import 'dart:io';

import 'package:event_finder/services/state.service.dart';
import 'package:event_finder/views/feature/shared/search_address_in_map.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../services/create_event.service.dart';
import '../../../../widgets/kk_button.dart';

class CePage3 extends StatefulWidget {
  const CePage3({Key? key}) : super(key: key);

  @override
  State<CePage3> createState() => _CePage3State();
}

class _CePage3State extends State<CePage3> {
  late Future<List<Placemark>> _getPlaceMarkers;

  @override
  void initState() {
    final mainLocation = StateService().currentUser!.mainLocation;
    _getPlaceMarkers = placemarkFromCoordinates(
        mainLocation.geoPoint.latitude, mainLocation.geoPoint.longitude);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Column(
        children: [
          FutureBuilder(
              future: _getPlaceMarkers,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                final placeMark = snapshot.data!.first;
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(Icons.location_on),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${placeMark.street}'),
                        Text('${placeMark.postalCode} ${placeMark.locality}'),
                      ],
                    ),
                    KKButton(
                        onPressed: () {
                          _showChangeLocation();
                        },
                        buttonText: 'Andere Location')
                  ],
                );
              }),
          const Divider(
            height: 50,
          ),
          if (CreateEventService().newEvent.selectedImageFile == null)
            SizedBox(
              width: 150,
              child: KKButton(
                  onPressed: () async {
                    final XFile? image = await ImagePicker()
                        .pickImage(source: ImageSource.gallery);
                    if (image == null) return;
                    setState(() {
                      CreateEventService().newEvent.selectedImageFile =
                          File(image.path);
                    });
                  },
                  buttonText: 'Bild hochladen'),
            ),
          if (CreateEventService().newEvent.selectedImageFile != null)
            Column(
              children: [
                SizedBox(
                    height: 300,
                    child: Image.file(
                        CreateEventService().newEvent.selectedImageFile!)),
                const SizedBox(
                  height: 20,
                ),
                IconButton(
                    onPressed: () {
                      setState(() {
                        CreateEventService().newEvent.selectedImageFile = null;
                      });
                    },
                    icon: const Icon(Icons.remove_circle))
              ],
            ),
        ],
      ),
    );
  }

  void _showChangeLocation() {
    GeoFirePoint? newCoordinates;
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: Container(
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    topRight: Radius.circular(10.0))),
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    height: 300,
                    clipBehavior: Clip.hardEdge,
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(12))),
                    child: SearchAddressInMap(onAddressSelected: (coordinates) {
                      newCoordinates = coordinates;
                    }),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: KKButton(
                    onPressed: () {
                      if (newCoordinates == null) return;
                      setState(() {
                        _getPlaceMarkers = placemarkFromCoordinates(
                            newCoordinates!.latitude,
                            newCoordinates!.longitude);
                        CreateEventService().newEvent.locationCoordinates =
                            newCoordinates;
                      });
                      Navigator.pop(context);
                    },
                    buttonText: 'Anwenden',
                  ),
                )
              ],
            )),
      ),
    );
  }
}

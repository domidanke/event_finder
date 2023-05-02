import 'dart:io';

import 'package:event_finder/models/event.dart';
import 'package:event_finder/services/state.service.dart';
import 'package:event_finder/views/feature/shared/search_address_in_map.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../widgets/kk_button.dart';

class CreateEventPage3 extends StatefulWidget {
  const CreateEventPage3({Key? key}) : super(key: key);

  @override
  State<CreateEventPage3> createState() => _CreateEventPage3State();
}

class _CreateEventPage3State extends State<CreateEventPage3> {
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
    NewEvent newEvent = StateService().newEvent;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              children: [
                const Spacer(),
                if (newEvent.selectedImageFile == null)
                  KKButton(
                      onPressed: () async {
                        final XFile? image = await ImagePicker()
                            .pickImage(source: ImageSource.gallery);
                        if (image == null) return;
                        setState(() {
                          newEvent.selectedImageFile = File(image.path);
                        });
                      },
                      buttonText: 'Bild hochladen'),
                if (newEvent.selectedImageFile != null)
                  Column(
                    children: [
                      SizedBox(
                          height: 300,
                          child: Image.file(newEvent.selectedImageFile!)),
                      const SizedBox(
                        height: 20,
                      ),
                      IconButton(
                          onPressed: () {
                            setState(() {
                              newEvent.selectedImageFile = null;
                            });
                          },
                          icon: const Icon(Icons.remove_circle))
                    ],
                  ),
                const Spacer(),
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
                              Text(
                                  '${placeMark.postalCode} ${placeMark.locality}'),
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
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    KKButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      buttonText: 'Zurück',
                    ),
                    Opacity(
                      opacity: newEvent.selectedImageFile == null ? 0.4 : 1,
                      child: KKButton(
                        onPressed: () {
                          if (newEvent.selectedImageFile == null) {
                            return;
                          }
                          Navigator.pushNamed(context, 'create_event_page_4');
                        },
                        buttonText: 'Weiter',
                      ),
                    ),
                  ],
                )
              ],
            )),
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
                        StateService().newEvent.locationCoordinates =
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
